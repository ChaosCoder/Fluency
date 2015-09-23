//
//  ExampleProcess.swift
//  Fluency
//
//  Created by Andreas Ganske on 22.09.15.
//  Copyright © 2015 Andreas Ganske. All rights reserved.
//

import Foundation
import UIKit

#if (arch(i386) || arch(x86_64)) && os(iOS)
let IS_SIMULATOR : Bool = true
	#else
let IS_SIMULATOR : Bool = false
#endif

class ExampleProcess : Process
{
	let getIsSimulator = ClosureTask(title: "Get is simulator") { () -> (Any?) in
		return IS_SIMULATOR
	}
	
	let isSimulator = ChoiceTask<Bool>(title: "Is simulator?")
	
	let getTestDeviceToken = ClosureTask(title: "Get test device token") { () -> (Any?) in
		return "SIMULATOR_TOKEN"
	}
	
	let generateKeypair = AsyncClosureTask(title: "Generate public key") { (_, completionHandler) -> () in
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) {
			completionHandler("publickey")
		}
	}
	
	let registerForPush = RegisterForRemoteNotificationsTask()
	
	let synchronize = SynchronizeTask()
	let merge = MergeTask()
	
	let registerCall = RegisterCall()
	
	override init()
	{
		super.init()
		
		rootTask = getIsSimulator → isSimulator
		
		isSimulator[true] → (generateKeypair | getTestDeviceToken)
		isSimulator → (generateKeypair | registerForPush)
		
		getTestDeviceToken → merge
		registerForPush → merge
		
		merge → synchronize["DeviceToken"]
		generateKeypair → synchronize["PublicKey"]
		
		registerForPush ↯ failureTask
		registerCall ↯ failureTask
		
		synchronize → registerCall → successTask
	}
}