import Foundation

class ExtractKeyTask: SequenceTask {
	let key : String
	
	init(key : String)
	{
		self.key = key

		super.init()

		self.title = "Extract \(key)"
	}

	required init(task: Task)
	{
		let extractKeyTask = task as! ExtractKeyTask
		key = extractKeyTask.key
		super.init(task: task)
	}
	
	override func execute()
	{
		let dic = context.result as! [String : Any]
		let result = dic[key]
		
		finish(result)
	}
}