import Foundation

class TimeoutTask: SequenceTask
{
	let timeInterval : NSTimeInterval
	
	init(timeInterval : NSTimeInterval)
	{
		self.timeInterval = timeInterval
		
		super.init()
	}
	
	required init(task: Task) {
		let timeoutTask = task as! TimeoutTask
		timeInterval = timeoutTask.timeInterval
		super.init(task: task)
	}
	
	override func execute()
	{
		let timer = NSTimer(timeInterval: timeInterval,
			target: self,
			selector: "fired:",
			userInfo: nil,
			repeats: false)
		
		NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
	}
	
	func fired(timer : NSTimer)
	{
		finish(nil)
	}
}