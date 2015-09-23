import Foundation

class FailableTask: Task
{
	var successTask : Task?
	var failureTask : Task?
	
	override func execute()
	{
		success(nil)
	}
	
	override init()
	{
		super.init()
	}
	
	required init(task: Task) {
		let failableTask = task as! FailableTask
		successTask = failableTask.successTask
		failureTask = failableTask.failureTask
		super.init(task: task)
	}

    final internal func success(result : Any?)
	{
		let context = Context(process: self.context.process, task: self.originalTask, result: result)
		finish(result)
		
		if let nextTask = successTask
		{
			nextTask.start(context)
		}
	}

    final internal func failure(error : NSError)
	{
		let context = Context(process: self.context.process, task: self.originalTask, result: error)
		finish(error)
		
		if let nextTask = failureTask
		{
			nextTask.start(context)
		}
		else
		{
			context.process.unhandledFailure(self, error: error, context: context)
		}
	}
	
	override func plantUML(visited: [Task]) -> String
	{
		var uml = "\"\(plantUMLDescription)\" as \(addressString)\n"
		
		if visited.contains(self) || plantUMLVisited > 0
		{
			return uml
		}
		
		plantUMLVisited++
		
		if successTask != nil || failureTask != nil
		{
			uml += "if \"\" then\n"
			if let successTask = successTask
			{
				uml += "--> " + successTask.plantUML(visited + [self])
			}
			else
			{
				uml += "-->[success] (*)\n"
			}
			
			uml += "else\n"
			if let failureTask = failureTask
			{
				uml += "-->[failure] " + failureTask.plantUML(visited + [self])
			}
			else
			{
				uml += "-->[failure] (*)\n"
			}
			
			uml += "endif\n"
		}
		
		return uml
	}
}