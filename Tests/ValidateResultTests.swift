// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import XCTest
@testable import SwiftyFORM

class ValidateResultTests: XCTestCase {

	func testCompare_same0() {
		let a = ValidateResult.valid
		let b = ValidateResult.valid
		XCTAssertEqual(a, b)
	}
	
	func testCompare_same1() {
		let a = ValidateResult.hardInvalid(message: "hello")
		let b = ValidateResult.hardInvalid(message: "hello")
		XCTAssertEqual(a, b)
	}
	
	func testCompare_same2() {
		let a = ValidateResult.softInvalid(message: "world")
		let b = ValidateResult.softInvalid(message: "world")
		XCTAssertEqual(a, b)
	}
	
	func testCompare_different0() {
		let a = ValidateResult.valid
		let b = ValidateResult.hardInvalid(message: "goodbye")
		XCTAssertNotEqual(a, b)
	}

	func testCompare_different1() {
		let a = ValidateResult.hardInvalid(message: "hello")
		let b = ValidateResult.hardInvalid(message: "goodbye")
		XCTAssertNotEqual(a, b)
	}
	
	func testCompare_different2() {
		let a = ValidateResult.valid
		let b = ValidateResult.softInvalid(message: "howdy")
		XCTAssertNotEqual(a, b)
	}

	func testCompare_different3() {
		let a = ValidateResult.softInvalid(message: "world")
		let b = ValidateResult.softInvalid(message: "candy")
		XCTAssertNotEqual(a, b)
	}
	
	func testCompare_different4() {
		let a = ValidateResult.hardInvalid(message: "hello")
		let b = ValidateResult.softInvalid(message: "candy")
		XCTAssertNotEqual(a, b)
	}
	
}
