//
//  ClosureTask.swift
//  ShareLoc
//
//  Created by Andreas Ganske on 10.12.14.
//  Copyright (c) 2014 Anbion. All rights reserved.
//

import Foundation

class ClosureTask: SequenceTask {
	
	internal let closure : (Any?) -> (Any?)
	
	init(closure : (Any?) -> (Any?))
	{
		self.closure = closure
		
		super.init()
	}
	
	convenience init(voidClosure : (Any?) -> ())
	{
		self.init(closure: {
			(result : Any?) in
			voidClosure(result)
			return nil
		})
	}

	convenience init(getClosure : () -> (Any?))
	{
		self.init(closure: {
			(result : Any?) in
			return getClosure()
		})
	}
	
	convenience init(title : String, closure : (Any?) -> (Any?))
	{
		self.init(closure: closure)
		
		self.title = title
	}

	convenience init(title : String, voidClosure : (Any?) -> ())
	{
		self.init(voidClosure: voidClosure)
		
		self.title = title
	}

	convenience init(title : String, getClosure : () -> (Any?))
	{
		self.init(getClosure: getClosure)

		self.title = title
	}
	
	required init(task: Task)
	{
		let closureTask = task as! ClosureTask
		closure = closureTask.closure
		super.init(task: task)
	}

    final override func execute()
	{
		let result = closure(context.result)
		finish(result)
	}
}