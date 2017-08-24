// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import XCTest
@testable import SwiftyFORM

class JSONHelperTests: XCTestCase {
    func testNil() {
		let value = JSONHelper.process(nil)
		XCTAssertTrue(value is NSNull)
    }
    
	func testNSNull() {
		let value = JSONHelper.process(NSNull())
		XCTAssertTrue(value is NSNull)
	}
	
	func testNone() {
		let s: String? = nil
		var dict = [String: Any?]()
		dict["id"] = s as Any?
		let obj: Any? = dict as Any?
		
		guard let dict2 = obj as? [String: Any?] else {
			XCTFail()
			return
		}
		let value: Any?? = dict2["id"]
		let processedValue = JSONHelper.process(value!)
		XCTAssertTrue(processedValue is NSNull)
	}
	
	func testInteger() {
		let i: Int = 123
		let value = JSONHelper.process(i)
		XCTAssertTrue(value is Int)
	}
	
	func testString() {
		let s: String = "hello"
		let value = JSONHelper.process(s)
		XCTAssertTrue(value is String)
	}
}
