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
