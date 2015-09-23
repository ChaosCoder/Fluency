//
//  GoogleKeywordsTask.swift
//  Fluency
//
//  Created by Andreas Ganske on 23.09.15.
//  Copyright © 2015 Andreas Ganske. All rights reserved.
//

import Foundation
import UIKit

class GoogleKeywordsTask : SequenceTask
{
	override func execute()
	{
		let result = context.result as! [String : Any]
		let animal = result["Animal"] as! String
		let verb = result["Verb"] as! String
		let url = NSURL(string: "https://www.google.de/search?tbm=isch&q=\(animal)+\(verb)")!
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
		UIApplication.sharedApplication().openURL(url)
	}
	
	func willEnterForeground(notification : NSNotification)
	{
		NSNotificationCenter.defaultCenter().removeObserver(self)
		finish(nil)
	}
}