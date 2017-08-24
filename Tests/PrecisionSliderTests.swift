// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation
import XCTest
@testable import SwiftyFORM

class PrecisionSliderTests: XCTestCase {
	func format0(_ value: Int) -> String {
		return PrecisionSliderCellFormatter.format(value: value, decimalPlaces: 0)
	}
	
	func format1(_ value: Int) -> String {
		return PrecisionSliderCellFormatter.format(value: value, decimalPlaces: 1)
	}

	func format3(_ value: Int) -> String {
		return PrecisionSliderCellFormatter.format(value: value, decimalPlaces: 3)
	}
	
	func testFormat0() {
		XCTAssertEqual(format0(0), "0")
		XCTAssertEqual(format0(1), "1")
		XCTAssertEqual(format0(-1), "-1")
		XCTAssertEqual(format0(234), "234")
		XCTAssertEqual(format0(-234), "-234")
		XCTAssertEqual(format0(1234), "1234")
		XCTAssertEqual(format0(-1234), "-1234")
		XCTAssertEqual(format0(123456), "123456")
		XCTAssertEqual(format0(-123456), "-123456")
	}
	
	func testFormat1() {
		XCTAssertEqual(format1(0), "0.0")
		XCTAssertEqual(format1(1), "0.1")
		XCTAssertEqual(format1(-1), "-0.1")
		XCTAssertEqual(format1(23_4), "23.4")
		XCTAssertEqual(format1(-23_4), "-23.4")
		XCTAssertEqual(format1(123_4), "123.4")
		XCTAssertEqual(format1(-123_4), "-123.4")
		XCTAssertEqual(format1(12345_6), "12345.6")
		XCTAssertEqual(format1(-12345_6), "-12345.6")
	}
	
	func testFormat3() {
		XCTAssertEqual(format3(0), "0.000")
		XCTAssertEqual(format3(1), "0.001")
		XCTAssertEqual(format3(-1), "-0.001")
		XCTAssertEqual(format3(234), "0.234")
		XCTAssertEqual(format3(-234), "-0.234")
		XCTAssertEqual(format3(1_234), "1.234")
		XCTAssertEqual(format3(-1_234), "-1.234")
		XCTAssertEqual(format3(123_456), "123.456")
		XCTAssertEqual(format3(-123_456), "-123.456")
	}
}
