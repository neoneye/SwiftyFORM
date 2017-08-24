// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

/// `Print` with additional info such as linenumber, filename
///
/// http://stackoverflow.com/questions/24114288/macros-in-swift
#if DEBUG
	func SwiftyFormLog(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
		print("[\(file):\(line)] \(function) - \(message)")
	}
#else
	func SwiftyFormLog(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
		// do nothing
	}
#endif
