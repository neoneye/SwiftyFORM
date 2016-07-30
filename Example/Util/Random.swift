// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import Foundation

public func randomInt(low: Int, _ high: Int) -> Int {
	let diff = high - low + 1
	return Int(arc4random_uniform(UInt32(diff))) + low
}
