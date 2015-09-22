//
//  NSObject+Address.swift
//  Fluency
//
//  Created by Andreas Ganske on 22.09.15.
//  Copyright © 2015 Andreas Ganske. All rights reserved.
//

import Foundation

extension NSObject
{
	var addressString : String {
		return String(format: "%p", address)
	}
	
	var address : Int {
		return unsafeBitCast(self, Int.self)
	}
}