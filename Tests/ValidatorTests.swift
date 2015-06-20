//
//  ValidatorTests.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 18/12/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit
import XCTest
@testable import SwiftyFORM

class ValidatorTests: XCTestCase {

    func testExample() {
		let builder = ValidatorBuilder()
		builder.hardValidate(FalseSpecification(), message: "rule0")
		let validator = builder.build()
		let actual: ValidateResult = validator.validate("hello", checkHardRule: true, checkSoftRule: true, checkSubmitRule: true)
		let expected = ValidateResult.HardInvalid(message: "rule0")
		XCTAssertEqual(expected, actual)
    }

}
