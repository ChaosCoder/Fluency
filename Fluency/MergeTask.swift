import Foundation

class MergeTask : SequenceTask
{
	override func execute()
	{
		finish(context.result)
	}
	
	override func plantUML(visited: [Task]) -> String
	{
		var uml = "===\(addressString)===\n"
		
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