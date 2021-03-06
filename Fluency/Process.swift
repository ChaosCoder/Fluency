import Foundation

class Process : NSObject
{
	var rootTask : Task!
	var successClosure : ((Any?) -> ())!
	var failureClosure : ((NSError?) -> ())!
	
	var successTask : Task {
		return ClosureTask(title: "SUCCESS", voidClosure: { (result : Any?) -> () in
			self.successClosure(result)
		})
	}
	
	var failureTask : Task {
		return ClosureTask(title: "FAILURE", voidClosure: { (result : Any?) -> () in
			self.failureClosure(result as? NSError)
		})
	}
	
	convenience init(task : Task)
	{
		self.init()
		
		self.rootTask = task
	}
	
	func execute()
	{
		execute(nil)
	}
	
	func execute(input : Any?)
	{
		let context = Context(process: self, task: nil, result: input)
		rootTask.start(context)
	}
	
	func className() -> String
	{
		let classString : String = NSStringFromClass(self.classForCoder)
		return classString.componentsSeparatedByString(".").last!
	}
	
	func unhandledFailure(task : Task, error : NSError, context : Context)
	{
		failureTask.start(context)
	}
	
	func plantUML() -> String
	{
		var code = "@startuml\n"
		
		code += "title \(self.className())\n"
		
		code += "(*) --> " + rootTask.plantUML([])
		
		code += "@enduml\n"
		
		return code
	}
}