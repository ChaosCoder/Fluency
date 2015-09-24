//
//  WorkProcess.swift
//  Fluency
//
//  Created by Andreas Ganske on 23.09.15.
//  Copyright © 2015 Andreas Ganske. All rights reserved.
//

import Foundation

class WorkProcess : Process
{
	let eatBreakfast = AsyncClosureTask(title: "Eat breakfast") { (input, completionHandler) -> () in
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) {
			let coin = Int(arc4random_uniform(2))
			completionHandler(coin == 1)
		}
	}
	
	let amIStillHungry = ChoiceTask<Bool>(title: "Still hungry?")
	
	let work = ClosureTask(title: "Pretend working") { _ in
		print("Pretend working...")
	}
	
	let getCoffee = ClosureTask(title: "Get coffee") { () -> (Any?) in
		return ["ingredients" : ["coffe", "sugar", "milk"], "temperature" : "hot"]
	}
	
	let thinkOfVerb = ClosureTask(title: "Think of verb") { () -> (Any?) in
		return "cooking"
	}
	
	let thinkOfAnimal = ClosureTask(title: "Think of animal") { () -> (Any?) in
		return "cat"
	}
	
	let syncKeywords = SynchronizeTask()
	
	let googleKeywords = GoogleKeywordsTask()

	let workedHours = ChoiceTask<Int>(title: "Worked Hours")
	
	let syncWork = SynchronizeTask()
	
	override init()
	{
		super.init()
		
		workedHours.getResultClosure = { _ in
			return 8
		}
		
		rootTask = eatBreakfast → amIStillHungry
		
		amIStillHungry[true] → eatBreakfast
		amIStillHungry → (work | getCoffee)
		
		getCoffee → (thinkOfVerb | thinkOfAnimal)
		
		thinkOfVerb → syncKeywords["Verb"]
		thinkOfAnimal → syncKeywords["Animal"]
		
		syncKeywords → googleKeywords → workedHours
		
		workedHours[8] → syncWork
		workedHours → getCoffee
		
		work → syncWork
		
		syncWork → successTask
	}
}