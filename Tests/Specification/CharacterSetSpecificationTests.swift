// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import XCTest
@testable import SwiftyFORM

class CharacterSetSpecificationTests: XCTestCase {
	
	func testCharactersInString() {
		let spec = CharacterSetSpecification.charactersInString("abc")
		XCTAssertTrue(spec.isSatisfiedBy(""))
		XCTAssertTrue(spec.isSatisfiedBy("abc"))
		XCTAssertFalse(spec.isSatisfiedBy("0123hello"))
		XCTAssertFalse(spec.isSatisfiedBy("hello"))
	}

	func testDecimalDigits() {
		let spec = CharacterSetSpecification.decimalDigits
		XCTAssertTrue(spec.isSatisfiedBy(""))
		XCTAssertTrue(spec.isSatisfiedBy("0123456789"))
		XCTAssertFalse(spec.isSatisfiedBy("0123hello"))
		XCTAssertFalse(spec.isSatisfiedBy("hello"))
	}
	
	func testWhitespacesAndNewlines() {
		let spec = CharacterSetSpecification.whitespacesAndNewlines
		XCTAssertTrue(spec.isSatisfiedBy(""))
		XCTAssertTrue(spec.isSatisfiedBy(" \t \n "))
		XCTAssertFalse(spec.isSatisfiedBy("---"))
		XCTAssertFalse(spec.isSatisfiedBy("###"))
	}
}
