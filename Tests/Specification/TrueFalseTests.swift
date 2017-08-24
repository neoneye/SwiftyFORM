// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import XCTest
@testable import SwiftyFORM

class TrueFalseTests: XCTestCase {
	
	func testTrue() {
		let spec = TrueSpecification()
		XCTAssertTrue(spec.isSatisfiedBy("hello world"))
		XCTAssertTrue(spec.isSatisfiedBy(nil))
	}
	
	func testFalse() {
		let spec = FalseSpecification()
		XCTAssertFalse(spec.isSatisfiedBy("world hello"))
		XCTAssertFalse(spec.isSatisfiedBy(nil))
	}
	
}
