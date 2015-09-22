//
//  AsyncClosureTask.swift
//  ShareLoc
//
//  Created by Andreas Ganske on 10.12.14.
//  Copyright (c) 2014 Anbion. All rights reserved.
//

import Foundation

class AsyncClosureTask : SequenceTask
{
	internal let closure : (Any?, (Any?) -> (Void)) -> ()
	
	convenience init(title : String, closure : (Any?, (Any?) -> (Void)) -> ())
	{
		self.init(closure: closure)
		
		self.title = title
	}

	
	init(closure : (Any?, (Any?) -> (Void)) -> ())
	{
		self.closure = closure
		
		super.init()
	}
	
	required init(task: Task) {
		let asyncClosureTask = task as! AsyncClosureTask
		closure = asyncClosureTask.closure
		super.init(task: task)
	}

    final override func execute()
	{
		let completionHandler = { (result : Any?) -> (Void) in
			self.finish(result)
		}
		
		closure(context.result, completionHandler)
	}
}