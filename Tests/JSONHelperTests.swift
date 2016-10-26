// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
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
		var dict = [String: AnyObject?]()
		dict["id"] = s as AnyObject?
		let obj: AnyObject? = dict as AnyObject?
		
		guard let dict2 = obj as? Dictionary<String, AnyObject?> else {
			XCTFail()
			return
		}
		let value = dict2["id"] as AnyObject?
		let processedValue = JSONHelper.process(value)
		XCTAssertTrue(processedValue is NSNull)
	}
	
	func testInteger() {
		let i: Int = 123
		let value = JSONHelper.process(i as AnyObject)
		XCTAssertTrue(value is Int)
	}
	
	func testString() {
		let s: String = "hello"
		let value = JSONHelper.process(s as AnyObject)
		XCTAssertTrue(value is String)
	}
}
