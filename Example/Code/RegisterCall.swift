//
//  RegisterCall.swift
//  Fluency
//
//  Created by Andreas Ganske on 22.09.15.
//  Copyright © 2015 Andreas Ganske. All rights reserved.
//

import Foundation

class RegisterCall : FailableTask {
	override func execute() {
		
		guard let result = context.result as? [String : Any] else {
			self.failure(NSError(domain: "errordomain", code: 1, userInfo: [NSLocalizedDescriptionKey : "Bad input context"]))
			return
		}
		
		guard let publicKey = result["PublicKey"] as? String,
		let deviceToken = result["DeviceToken"] as? String else {
			self.failure(NSError(domain: "errordomain", code: 1, userInfo: [NSLocalizedDescriptionKey : "Bad values"]))
			return
		}
		
		let url = NSURL(string: "https://example.com/register?publicKey=\(publicKey)&device=\(deviceToken)")!
		let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url) {
			(data, response, error) in
			
			if let error = error {
				self.failure(error)
				return
			}
			
			self.success(data)
		}
		
		dataTask.resume()
	}
}