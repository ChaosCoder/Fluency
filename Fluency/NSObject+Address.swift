import Foundation

extension NSObject
{
	var addressString : String {
		let string = String(format: "%p", address)
		let index = string.startIndex.advancedBy(2)
		
		return string.substringFromIndex(index)
	}
	
	var address : Int {
		return unsafeBitCast(self, Int.self)
	}
}