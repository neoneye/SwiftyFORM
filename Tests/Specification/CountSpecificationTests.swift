// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import XCTest
@testable import SwiftyFORM

class CountSpecificationTests: XCTestCase {
	
	func testStringMin() {
		let spec = CountSpecification.min(3)
		XCTAssertFalse(spec.isSatisfiedBy(nil))
		XCTAssertFalse(spec.isSatisfiedBy(""))
		XCTAssertFalse(spec.isSatisfiedBy("0"))
		XCTAssertFalse(spec.isSatisfiedBy("01"))
		XCTAssertTrue(spec.isSatisfiedBy("012"))
		XCTAssertTrue(spec.isSatisfiedBy("0123"))
	}
	
	func testStringMax() {
		let spec = CountSpecification.max(2)
		XCTAssertTrue(spec.isSatisfiedBy(""))
		XCTAssertTrue(spec.isSatisfiedBy("0"))
		XCTAssertTrue(spec.isSatisfiedBy("01"))
		XCTAssertFalse(spec.isSatisfiedBy("012"))
		XCTAssertFalse(spec.isSatisfiedBy("0123"))
	}
	
	func testStringBetween() {
		let spec = CountSpecification.between(2, 4)
		XCTAssertFalse(spec.isSatisfiedBy(""))
		XCTAssertFalse(spec.isSatisfiedBy("0"))
		XCTAssertTrue(spec.isSatisfiedBy("01"))
		XCTAssertTrue(spec.isSatisfiedBy("012"))
		XCTAssertTrue(spec.isSatisfiedBy("0123"))
		XCTAssertFalse(spec.isSatisfiedBy("01234"))
		XCTAssertFalse(spec.isSatisfiedBy("012345"))
	}

	func testStringExcactly() {
		let spec = CountSpecification.exactly(2)
		XCTAssertFalse(spec.isSatisfiedBy(""))
		XCTAssertFalse(spec.isSatisfiedBy("0"))
		XCTAssertTrue(spec.isSatisfiedBy("01"))
		XCTAssertFalse(spec.isSatisfiedBy("012"))
		XCTAssertFalse(spec.isSatisfiedBy("0123"))
	}
	
	func testArrayMin() {
		let array0: [Bool] = []
		let spec = CountSpecification.min(3)
		XCTAssertFalse(spec.isSatisfiedBy( array0 ))
		XCTAssertFalse(spec.isSatisfiedBy( [0] ))
		XCTAssertFalse(spec.isSatisfiedBy( [0, 1] ))
		XCTAssertTrue(spec.isSatisfiedBy( [0, 1, 2] ))
		XCTAssertTrue(spec.isSatisfiedBy( [0, 1, 2, 3] ))
	}
	
	func testArrayMax() {
		let array0: [Bool] = []
		let spec = CountSpecification.max(2)
		XCTAssertTrue(spec.isSatisfiedBy( array0 ))
		XCTAssertTrue(spec.isSatisfiedBy( [0] ))
		XCTAssertTrue(spec.isSatisfiedBy( [0, 1] ))
		XCTAssertFalse(spec.isSatisfiedBy( [0, 1, 2] ))
		XCTAssertFalse(spec.isSatisfiedBy( [0, 1, 2, 3] ))
	}

	func testArrayBetween() {
		let array0: [Bool] = []
		let spec = CountSpecification.between(2, 4)
		XCTAssertFalse(spec.isSatisfiedBy(array0))
		XCTAssertFalse(spec.isSatisfiedBy( [0] ))
		XCTAssertTrue(spec.isSatisfiedBy( [0, 1] ))
		XCTAssertTrue(spec.isSatisfiedBy( [0, 1, 2] ))
		XCTAssertTrue(spec.isSatisfiedBy( [0, 1, 2, 3] ))
		XCTAssertFalse(spec.isSatisfiedBy( [0, 1, 2, 3, 4] ))
		XCTAssertFalse(spec.isSatisfiedBy( [0, 1, 2, 3, 4, 5] ))
	}
	
	func testArrayExactly() {
		let array0: [Bool] = []
		let spec = CountSpecification.exactly(2)
		XCTAssertFalse(spec.isSatisfiedBy(array0))
		XCTAssertFalse(spec.isSatisfiedBy( [0] ))
		XCTAssertTrue(spec.isSatisfiedBy( [0, 1] ))
		XCTAssertFalse(spec.isSatisfiedBy( [0, 1, 2] ))
		XCTAssertFalse(spec.isSatisfiedBy( [0, 1, 2, 3] ))
	}
	
}
