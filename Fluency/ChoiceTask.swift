import Foundation

class ChoiceTask<T where T : Hashable> : Task
{
	var nextTask : Dictionary<T, Task>
	var defaultTask : Task?
	var getResultClosure : ((Any?) -> (T?))?

    convenience init(title : String)
    {
        self.init()
        self.title = title
    }

	override init()
	{
		self.nextTask = [:]
		
		super.init()
	}

	required init(task: Task) {
	    let choiceTask = task as! ChoiceTask<T>
		nextTask = choiceTask.nextTask
		defaultTask = choiceTask.defaultTask
		getResultClosure = choiceTask.getResultClosure
		super.init(task: task)
	}

	subscript(key: T) -> (ChoiceTask<T>, T) {
		return (self, key)
	}
	
	func getResult(result : Any?) -> T?
	{
		if let getResultClosure = getResultClosure
		{
			return getResultClosure(result)
		}
		else
		{
			return result as? T
		}
	}
	
	final override func execute()
	{
		var task = defaultTask
		let key = getResult(context.result)
		
		if let key = key
		{
			if let nextTask = nextTask[key]
			{
				task = nextTask
			}
		}
		
		let nextContext = Context(process: context.process, task: self.originalTask, result: context.result)
		finish(context.result)
		
		if let nextTask = task
		{
			nextTask.start(nextContext)
		}
	}
	
	override func plantUML(visited : [Task]) -> String
	{
		var uml = ""
		
		if visited.contains(self)
		{
			return uml
		}
		
		uml += "if \"\(plantUMLDescription)\" then\n"
		
		if nextTask.count > 0
		{
			var i = 0
			for (key, task) in nextTask
			{
				if i > 0
				{
					uml += "else\n"
				}
				
				uml += "-->[\(key)] " + task.plantUML(visited + [self])
	
				i++
			}
		}
		
		uml += "else\n"
		
		if let defaultTask = defaultTask
		{
			uml += "-->[default] " + defaultTask.plantUML(visited + [self])
		}
		else
		{
			uml += "--> (*)\n"
		}
		
		uml += "endif\n"
		
		return uml
	}
}