// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import XCTest
@testable import SwiftyFORM

class PrevNextMockTableView: UITableView {
	let numberOfRowsInSectionData: [Int]
	
	init(numberOfRowsInSectionData: [Int]) {
		self.numberOfRowsInSectionData = numberOfRowsInSectionData
		super.init(frame: CGRect.zero, style: .plain)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func numberOfRows(inSection section: Int) -> Int {
		return numberOfRowsInSectionData[section]
	}
	
	override var numberOfSections: Int {
		return numberOfRowsInSectionData.count
	}
}

class PrevNextTests: XCTestCase {
	
	func prev(_ row: Int, _ section: Int, _ tableView: UITableView) -> IndexPath? {
		return IndexPath(row: row, section: section).form_indexPathForPreviousCell(tableView)
	}
	
	func next(_ row: Int, _ section: Int, _ tableView: UITableView) -> IndexPath? {
		return IndexPath(row: row, section: section).form_indexPathForNextCell(tableView)
	}
	
	func makeTableView(_ numberOfRowsInSectionData: [Int]) -> UITableView {
		return PrevNextMockTableView(numberOfRowsInSectionData: numberOfRowsInSectionData)
	}
	
	func makeIndexPath(_ row: Int, _ section: Int) -> IndexPath {
		return IndexPath(row: row, section: section)
	}

	// MARK: Previous
	
	func testPrev0sections() {
		let tv = makeTableView([])
		XCTAssertNil(prev(0, 0, tv))
	}

	func testPrev1section0row() {
		let tv = makeTableView([0])
		XCTAssertNil(prev(0, 0, tv))
		XCTAssertNil(prev(1, 0, tv))
		XCTAssertNil(prev(2, 0, tv))
	}
	
	func testPrev1section1row() {
		let tv = makeTableView([1])
		XCTAssertNil(prev(0, 0, tv))
		XCTAssertEqual(makeIndexPath(0, 0), prev(1, 0, tv)!)
		XCTAssertNil(prev(2, 0, tv))
	}

	func testPrev1section2rows() {
		let tv = makeTableView([2])
		XCTAssertNil(prev(0, 0, tv))
		XCTAssertEqual(makeIndexPath(0, 0), prev(1, 0, tv)!)
		XCTAssertEqual(makeIndexPath(1, 0), prev(2, 0, tv)!)
		XCTAssertNil(prev(3, 0, tv))
	}
	
	func testPrev3sectionSkipEmptySection() {
		let tv = makeTableView([7, 0, 7])
		XCTAssertEqual(makeIndexPath(6, 0), prev(0, 2, tv)!)
	}
	
	func testPrev3sectionEmptyTailingSections() {
		let tv = makeTableView([0, 0, 7])
		XCTAssertNil(prev(0, 3, tv))
		XCTAssertNil(prev(0, 2, tv))
	}

	// MARK: Next
	
	func testNext0sections() {
		let tv = makeTableView([])
		XCTAssertNil(next(0, 0, tv))
	}

	func testNext1section0row() {
		let tv = makeTableView([0])
		XCTAssertNil(next(-2, 0, tv))
		XCTAssertNil(next(-1, 0, tv))
		XCTAssertNil(next(0, 0, tv))
	}
	
	func testNext1section1row() {
		let tv = makeTableView([1])
		XCTAssertNil(next(-2, 0, tv))
		XCTAssertEqual(makeIndexPath(0, 0), next(-1, 0, tv)!)
		XCTAssertNil(next(0, 0, tv))
	}

	func testNext1section2rows() {
		let tv = makeTableView([2])
		XCTAssertNil(next(-2, 0, tv))
		XCTAssertEqual(makeIndexPath(0, 0), next(-1, 0, tv)!)
		XCTAssertEqual(makeIndexPath(1, 0), next(0, 0, tv)!)
		XCTAssertNil(next(1, 0, tv))
		XCTAssertNil(next(2, 0, tv))
	}

	func testNext3sectionSkipEmptySection() {
		let tv = makeTableView([7, 0, 7])
		XCTAssertEqual(makeIndexPath(0, 2), next(6, 0, tv)!)
	}
	
	func testNext3sectionEmptyTailingSections() {
		let tv = makeTableView([7, 0, 0])
		XCTAssertNil(next(0, -1, tv))
		XCTAssertNil(next(6, 0, tv))
	}
	
}
