// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import XCTest
@testable import SwiftyFORM

class EmailSpecificationTests: XCTestCase {
	
	func testBasic() {
		let spec = EmailSpecification()
		XCTAssertFalse(spec.isSatisfiedBy(nil))
		XCTAssertFalse(spec.isSatisfiedBy(""))
		XCTAssertFalse(spec.isSatisfiedBy("not a valid email"))
		XCTAssertFalse(spec.isSatisfiedBy("0123456789"))
		XCTAssertFalse(spec.isSatisfiedBy("Abc.example.com"))       // an @ character must separate the local and domain parts
		XCTAssertFalse(spec.isSatisfiedBy("john.doe@example..com")) // double dot after @
		XCTAssertFalse(spec.isSatisfiedBy("@example.com"))
		XCTAssertTrue(spec.isSatisfiedBy("john-doe@example.com"))
		XCTAssertTrue(spec.isSatisfiedBy("John.Smith@example.com"))
		XCTAssertTrue(spec.isSatisfiedBy("jsmith@[192.168.2.1]"))
		XCTAssertTrue(spec.isSatisfiedBy("jsmith@192.168.2.1"))
		XCTAssertTrue(spec.isSatisfiedBy("disposable.style.email.with+symbol@example.com"))
		XCTAssertTrue(spec.isSatisfiedBy("hello@subdomain.example.co.jp"))
		XCTAssertTrue(spec.isSatisfiedBy("spaces\\ are\\ allowed@example.com"))
	}
	
}
