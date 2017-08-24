// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import XCTest
@testable import SwiftyFORM

class RegularExpressionSpecificationTests: XCTestCase {
	
	func testSimple() {
		let spec = RegularExpressionSpecification(pattern: "^\\d+$")
		XCTAssertTrue(spec.isSatisfiedBy("123"))
		XCTAssertFalse(spec.isSatisfiedBy("abc"))
		XCTAssertFalse(spec.isSatisfiedBy(nil))
	}
	
}
