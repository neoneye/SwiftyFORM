// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import XCTest
@testable import SwiftyFORM

class ValidatorTests: XCTestCase {

    func testExample() {
		let builder = ValidatorBuilder()
		builder.hardValidate(FalseSpecification(), message: "rule0")
		let validator = builder.build()
		let actual: ValidateResult = validator.validate("hello", checkHardRule: true, checkSoftRule: true, checkSubmitRule: true)
		let expected = ValidateResult.hardInvalid(message: "rule0")
		XCTAssertEqual(expected, actual)
    }

}
