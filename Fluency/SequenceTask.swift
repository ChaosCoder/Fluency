import Foundation

class SequenceTask : Task
{
	var nextTask : Task? {
		willSet {
			assert(nextTask == nil, "Trying to overwrite next task of sequence task... Intended?")
		}
	}
	
	override init()
	{
		super.init()
	}
	
	convenience init(title : String)
	{
		self.init()
		
		self.title = title
	}
	
	required init(task : Task)
	{
		let sequenceTask = task as! SequenceTask
		nextTask = sequenceTask.nextTask
		super.init(task: task)
	}
	
	final override func finish(result : Any?)
	{
		let context = Context(process: self.context.process, task: self.originalTask, result: result)
		super.finish(result)
		
		if let nextTask = nextTask
		{
			nextTask.start(context)
		}
	}
	
	override func plantUML(visited : [Task]) -> String
	{
		var uml = ""
		
		if plantUMLVisited == 0
		{
			uml += "\"\(plantUMLDescription)\" as \(addressString)\n"
		}
		else
		{
			uml += "\(addressString)\n"
		}
		
		if visited.contains(self)
		{
			return uml
		}
		
		if plantUMLVisited == 0
		{
			if let nextTask = nextTask
			{
				uml += "\(addressString) --> " + nextTask.plantUML(visited + [self])
			}
			else
			{
				uml += "\(addressString) --> (*)\n"
			}
		}
		
		plantUMLVisited++
		return uml
	}
}