// MIT license. Copyright (c) 2018 SwiftyFORM. All rights reserved.
import Foundation

extension Dictionary {
	/// merge two dictionaries into one dictionary
	mutating func update(_ other: Dictionary) {
		for (key, value) in other {
			self.updateValue(value, forKey:key)
		}
	}
}
