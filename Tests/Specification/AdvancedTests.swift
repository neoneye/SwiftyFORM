// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import XCTest
@testable import SwiftyFORM

class AdvancedTests: XCTestCase {
	
	func testAdvanced0() {
		/*
		This specification checks these contraints
		1. the string must be all digits
		2. the string.length must be between 2..4
		3. the string must not contain two zeroes
		*/
		let onlyDigits = CharacterSetSpecification.decimalDigits
		let between2And4Letters = CountSpecification.between(2, 4)
		let twoZeroes = RegularExpressionSpecification(pattern: "0.*0")
		
		let spec = onlyDigits.and(between2And4Letters).and(twoZeroes.not())
		
		XCTAssertTrue(spec.isSatisfiedBy("42"))
		XCTAssertTrue(spec.isSatisfiedBy("0123"))
		XCTAssertTrue(spec.isSatisfiedBy("666"))
		XCTAssertFalse(spec.isSatisfiedBy("ice"))
		XCTAssertFalse(spec.isSatisfiedBy("too long"))
		XCTAssertFalse(spec.isSatisfiedBy("00"))
		XCTAssertFalse(spec.isSatisfiedBy("1010"))
		XCTAssertFalse(spec.isSatisfiedBy(nil))
	}
	
	func testFilter0() {
		/*
		This specification is used for filtering an array of records (movies in the alien franchise).
		Here we finds all the movies directed by Ridley Scott.
		*/
		let spec = RegularExpressionSpecification(pattern: "Ridley Scott")
		let filterSpec = PredicateSpecification { (candidate: MovieRecord) -> Bool in
			return spec.isSatisfiedBy(candidate.directorsWriters)
		}
		let result = movieRecords().filter { filterSpec.isSatisfiedBy($0) }
		// Ridley Scott has directed 2 movies: Alien and Prometheus
		XCTAssertEqual(2, result.count)
	}

	func testFilter1() {
		/*
		This specification is used for filtering an array of records (movies in the alien franchise).
		Here we finds the cheapest movies and also the most expensive movies.
		*/
		let nonZeroBudget = PredicateSpecification { (candidate: MovieRecord) -> Bool in
			return candidate.budget > 0
		}
		let smallBudget = PredicateSpecification { (candidate: MovieRecord) -> Bool in
			// cheaper than 20 millions USD
			return candidate.budget < 20
		}
		let bigBudget = PredicateSpecification { (candidate: MovieRecord) -> Bool in
			// more expensive than 70 millions USD
			return candidate.budget > 70
		}
		let filterSpec = nonZeroBudget.and(smallBudget.or(bigBudget))
		let result = movieRecords().filter { filterSpec.isSatisfiedBy($0) }
		// There are 2 cheap movies and 2 expensive movies
		XCTAssertEqual(4, result.count)
	}
	
	class MovieRecord {
		var recordId: Int = 0
		var name: String = ""
		var released: Int = 0
		var directorsWriters: String = ""
		var budget: Double = 0.0
		var runningTime: Int = 0
	}
	
	func movieRecords() -> [MovieRecord] {
		// Read a CSV file
		let path: String! = Bundle(for: type(of: self)).path(forResource: "AdvancedTests", ofType: "csv")
		assert(path != nil)
		let dataString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)

		// Split CSV data into rows and fields
		let rows = dataString.components(separatedBy: "\n")
		var records: [MovieRecord] = []
		for row in rows {
			let cells = row.components(separatedBy: ";")
			assert(cells.count == 6)
			
			// Create record populated with CSV data
			let record: MovieRecord = MovieRecord()
			record.recordId = Int(cells[0]) ?? 0
			record.name = cells[1]
			record.released = Int(cells[2]) ?? 0
			record.directorsWriters = cells[3]
			record.budget = Double(cells[4]) ?? 0.0
			record.runningTime = Int(cells[5]) ?? 0
			records.append(record)
		}
		
		return records
	}
	
}
