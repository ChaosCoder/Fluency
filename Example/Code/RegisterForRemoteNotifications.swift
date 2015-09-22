//
//  RegisterForPushNotifications.swift
//  Fluency
//
//  Created by Andreas Ganske on 22.09.15.
//  Copyright © 2015 Andreas Ganske. All rights reserved.
//

import Foundation
import UIKit

class RegisterForRemoteNotificationsTask: FailableTask
{
	override func execute() {
		let notificationCenter = NSNotificationCenter.defaultCenter()
		
		notificationCenter.addObserver(self,
			selector: "didRegisterForRemoteNotificationsWithDeviceToken:",
			name: "DidRegisterForRemoteNotificationsWithDeviceToken",
			object: nil)
		
		notificationCenter.addObserver(self,
			selector: "didFailToRegisterForRemoteNotificationsWithError:",
			name: "DidFailToRegisterForRemoteNotificationsWithError",
			object: nil)
		
		let userNotificationSettings = UIUserNotificationSettings(forTypes:.Alert, categories: nil)
		
		UIApplication.sharedApplication().registerUserNotificationSettings(userNotificationSettings)
		UIApplication.sharedApplication().registerForRemoteNotifications()
	}
	
	func didRegisterForRemoteNotificationsWithDeviceToken(notification : NSNotification)
	{
		NSNotificationCenter.defaultCenter().removeObserver(self)
		
		let userInfo = notification.userInfo as! [String : AnyObject]
		let deviceToken : String = userInfo["DeviceToken"] as! String
		
		success(deviceToken)
	}
	
	func didFailToRegisterForRemoteNotificationsWithError(notification : NSNotification)
	{
		NSNotificationCenter.defaultCenter().removeObserver(self)
		
		let userInfo = notification.userInfo as! [String : AnyObject]?
		let error = userInfo!["Error"] as! NSError
		
		failure(error)
	}
}