// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import XCTest
@testable import SwiftyFORM

class ValidateResultTests: XCTestCase {

	func testCompare_same0() {
		let a = ValidateResult.Valid
		let b = ValidateResult.Valid
		XCTAssertEqual(a, b)
	}
	
	func testCompare_same1() {
		let a = ValidateResult.HardInvalid(message: "hello")
		let b = ValidateResult.HardInvalid(message: "hello")
		XCTAssertEqual(a, b)
	}
	
	func testCompare_same2() {
		let a = ValidateResult.SoftInvalid(message: "world")
		let b = ValidateResult.SoftInvalid(message: "world")
		XCTAssertEqual(a, b)
	}
	
	func testCompare_different0() {
		let a = ValidateResult.Valid
		let b = ValidateResult.HardInvalid(message: "goodbye")
		XCTAssertNotEqual(a, b)
	}

	func testCompare_different1() {
		let a = ValidateResult.HardInvalid(message: "hello")
		let b = ValidateResult.HardInvalid(message: "goodbye")
		XCTAssertNotEqual(a, b)
	}
	
	func testCompare_different2() {
		let a = ValidateResult.Valid
		let b = ValidateResult.SoftInvalid(message: "howdy")
		XCTAssertNotEqual(a, b)
	}

	func testCompare_different3() {
		let a = ValidateResult.SoftInvalid(message: "world")
		let b = ValidateResult.SoftInvalid(message: "candy")
		XCTAssertNotEqual(a, b)
	}
	
	func testCompare_different4() {
		let a = ValidateResult.HardInvalid(message: "hello")
		let b = ValidateResult.SoftInvalid(message: "candy")
		XCTAssertNotEqual(a, b)
	}
	
}
