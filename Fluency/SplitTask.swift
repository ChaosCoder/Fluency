//
//  SplitTask.swift
//  ShareLoc
//
//  Created by Andreas Ganske on 23.01.15.
//  Copyright (c) 2015 Anbion. All rights reserved.
//

import Foundation

class SplitTask : Task
{
	var nextTasks : [Task]
	
	override init()
	{
		nextTasks = []
		
		super.init()
	}

	required init(task: Task) {
		let splitTask = task as! SplitTask
		nextTasks = splitTask.nextTasks
	    super.init(task: task)
	}

    final override func execute()
	{
		let nextContext = Context(process:self.context.process, task: self.originalTask, result: self.context.result)
		finish(self.context.result)
		
		for task in nextTasks
		{
			task.start(nextContext)
		}
	}
	
	override func plantUML(visited: [Task]) -> String
	{
		var uml = "===\(addressString)===\n"
		
		if visited.contains(self) || plantUMLVisited > 0
		{
			return uml
		}
		
		for task in nextTasks
		{
			uml += "===\(addressString)=== --> " + task.plantUML(visited + [self])
		}
		
		return uml
	}
}