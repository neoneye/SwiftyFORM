// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import XCTest
@testable import SwiftyFORM

class PredicateSpecificationTests: XCTestCase {
	
	func testString0() {
		let spec = PredicateSpecification { (candidate: String) -> Bool in
			return candidate.hasPrefix("hello")
		}
		XCTAssertTrue(spec.isSatisfiedBy("hello world"))
		XCTAssertTrue(spec.isSatisfiedBy("hello lambda world"))
		XCTAssertFalse(spec.isSatisfiedBy("hell"))
		XCTAssertFalse(spec.isSatisfiedBy(""))
		XCTAssertFalse(spec.isSatisfiedBy("nope"))
		XCTAssertFalse(spec.isSatisfiedBy(1234))
		XCTAssertFalse(spec.isSatisfiedBy(nil))
	}
	
	func testInteger0() {
		let spec = PredicateSpecification { (candidate: Int) -> Bool in
			return candidate > 5
		}
		XCTAssertTrue(spec.isSatisfiedBy(10))
		XCTAssertFalse(spec.isSatisfiedBy(0))
		XCTAssertFalse(spec.isSatisfiedBy("not integer"))
		XCTAssertFalse(spec.isSatisfiedBy(nil))
		XCTAssertFalse(spec.isSatisfiedBy(10.0)) // float is not integer, thus it's false
	}
	
	func testCustomer0() {
		class Customer {
			let name: String
			init(name: String) {
				self.name = name
			}
		}
		
		let spec = PredicateSpecification { (candidate: Customer) -> Bool in
			return candidate.name.hasPrefix("john")
		}
		XCTAssertTrue(spec.isSatisfiedBy(Customer(name: "john doe")))
		XCTAssertFalse(spec.isSatisfiedBy(Customer(name: "jane doe")))
		XCTAssertFalse(spec.isSatisfiedBy(0))
		XCTAssertFalse(spec.isSatisfiedBy("not a customer"))
		XCTAssertFalse(spec.isSatisfiedBy(nil))
		XCTAssertFalse(spec.isSatisfiedBy(10.0))
	}
	
}
