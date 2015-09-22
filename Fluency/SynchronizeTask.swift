//
//  MergeTask.swift
//  ShareLoc
//
//  Created by Andreas Ganske on 10.12.14.
//  Copyright (c) 2014 Anbion. All rights reserved.
//

import Foundation

class SynchronizeTask: SequenceTask
{
	internal var dependencies : [String : [Task]]
	internal var result : [String : Any]
	
	var plantUMLNumber = 0
	
	override init()
	{
		dependencies = [:]
		result = [:]
		super.init()
	}
	
	required init(task: Task) {
		let synchronizeTask = task as! SynchronizeTask
		dependencies = synchronizeTask.dependencies
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
			dependencies.removeValueForKey(key)
			
			if dependencies.isEmpty
			{
				finish(result)
			}
		}
	}
	
	func keyForTask(task : Task) -> String?
	{
		for (key, tasks) in dependencies
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
	
	func addDependency(task : Task, key : String)
	{
		var tasks = dependencies[key]
		
		if tasks != nil
		{
			tasks!.append(task)
		}
		else
		{
			dependencies[key] = [task]
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