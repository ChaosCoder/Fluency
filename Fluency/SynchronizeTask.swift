import Foundation

class SynchronizeTask: SequenceTask
{
	internal var dependencies : [Task]
	internal var dependenciesWithKeys : [String : [Task]]
	internal var result : [String : Any]
	
	var plantUMLNumber = 0
	
	override init()
	{
		dependencies = []
		dependenciesWithKeys = [:]
		result = [:]
		
		super.init()
	}
	
	required init(task: Task) {
		let synchronizeTask = task as! SynchronizeTask
		dependencies = synchronizeTask.dependencies
		dependenciesWithKeys = synchronizeTask.dependenciesWithKeys
		result = synchronizeTask.result
		super.init(task: task)
	}
	
	override func start(context: Context)
	{
		self.originalTask = self
		self.context = context
		
		let prevTask = context.task!
		
		if let key = keyForTask(prevTask)
		{
			result[key] = context.result
			dependenciesWithKeys.removeValueForKey(key)
		}
		
		if let index = dependencies.indexOf(prevTask)
		{
			dependencies.removeAtIndex(index)
		}
		
		if dependencies.isEmpty && dependenciesWithKeys.isEmpty
		{
			finish(result)
		}
	}
	
	func keyForTask(task : Task) -> String?
	{
		for (key, tasks) in dependenciesWithKeys
		{
			if tasks.contains(task)
			{
				return key
			}
		}
		
		return nil
	}
	
	subscript(key: String) -> (SynchronizeTask, String) {
		return (self, key)
	}
	
	func addDependency(task : Task, key : String? = nil)
	{
		if let key = key
		{
			var tasks = dependenciesWithKeys[key]
			
			if tasks != nil
			{
				tasks!.append(task)
			}
			else
			{
				dependenciesWithKeys[key] = [task]
			}
		}
		else
		{
			dependencies.append(task)
		}
	}
	
	override func plantUML(visited: [Task]) -> String
	{
		var uml = ""
		
		let prevTask = visited.last!
		
		if let key = keyForTask(prevTask)
		{
			uml += "[\(key)] "
		}
		
		uml += "===\(addressString)===\n"
		
		if visited.contains(self) || plantUMLVisited > 0
		{
			return uml
		}
		
		plantUMLVisited++
		if let nextTask = nextTask
		{
			uml += "--> " + nextTask.plantUML(visited + [self])
		}
		else
		{
			uml += "--> (*)\n"
		}
		
		return uml
	}
}