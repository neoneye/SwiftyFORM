// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import Foundation

// http://stackoverflow.com/questions/24114288/macros-in-swift
#if DEBUG
	func DLog(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
		print("[\(file.lastPathComponent):\(line)] \(function) - \(message)")
	}
#else
	func DLog(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
		// do nothing
	}
#endif


