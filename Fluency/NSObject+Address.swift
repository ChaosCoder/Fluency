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