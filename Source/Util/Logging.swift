// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import Foundation

// http://stackoverflow.com/questions/24114288/macros-in-swift
#if DEBUG
	func SwiftyFormLog(message: String, function: String = #function, file: String = #file, line: Int = #line) {
		print("[\(file):\(line)] \(function) - \(message)")
	}
#else
	func SwiftyFormLog(message: String, function: String = #function, file: String = #file, line: Int = #line) {
		// do nothing
	}
#endif


