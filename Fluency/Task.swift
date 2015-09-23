import Foundation

class Task : NSObject
{
	var originalTask : Task!
	var context : Context!
	var subTasks : [Task]!
	
	var title : String?
	var plantUMLDescription : String{
		get {
			return title != nil ? title! : className()
		}
	}
	var plantUMLStop : Bool = false
	var plantUMLVisited = 0
	
	override init()
	{
	}
	
	required init(task : Task)
	{
		originalTask = task.originalTask
		title = task.title
	}
	
	internal func start(context : Context)
	{
		if subTasks == nil
		{
			subTasks = []
		}
		
		let newTask = self.copyTask()
		newTask.originalTask = self
		newTask.context = context
		subTasks.append(newTask)
		
		#if DEBUG
			print("Started task \"\(newTask.plantUMLDescription)\"")
		#endif
		
		newTask.execute()
	}
	
	func execute()
	{
		assertionFailure("You must override execute!")
	}
	
	internal func finish(result : Any?)
	{
		#if DEBUG
			print("Finished task \"\(plantUMLDescription)\" with result: \(result)")
		#endif
		
		self.originalTask = nil
		self.context = nil
	}
	
	func copyTask() -> Task
	{
		return self.dynamicType.init(task: self)
	}
	
	func className() -> String
	{
		let classString : String = NSStringFromClass(self.classForCoder)
		return classString.componentsSeparatedByString(".").last!
	}
	
	func plantUML(visited : [Task]) -> String
	{
		let uml = "\"\(plantUMLDescription)\" as \(addressString)\n"
		
		return uml
	}
}