//
//  ForEachTask.swift
//  ShareLoc
//
//  Created by Andreas Ganske on 23.01.15.
//  Copyright (c) 2015 Anbion. All rights reserved.
//

import Foundation

class ForEachTask<T> : SequenceTask
{
	var forEachTask : Task?
	
	override init()
	{
		super.init()
	}
	
	required init(task: Task)
	{
		let forEachTask = task as! ForEachTask
		self.forEachTask = forEachTask.forEachTask
		super.init(task: task)
	}

    final override func execute()
	{
		let array : [T] = context.result as! [T]

		let process = context.process
		finish(context.result)
		
		if let forEachTask = forEachTask
		{
			for object in array
			{
				forEachTask.start(Context(process:process, task: self.originalTask, result: object))
			}
		}
	}
	
	override func plantUML(visited: [Task]) -> String
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
			if let forEachTask = forEachTask
			{
				uml += "-right->[foreach] " + forEachTask.plantUML(visited + [self])
			}
			
			if let nextTask = nextTask
			{
				uml += "\(addressString) -down->[default] " + nextTask.plantUML(visited + [self])
			}
			else
			{
				uml += "\(addressString) -down->[default] (*)\n"
			}
		}
		
		return uml
	}
}