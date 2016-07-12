// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class CellWrapper {
	let cell: UITableViewCell
	var hidden: Bool
	
	init(cell: UITableViewCell, hidden: Bool) {
		self.cell = cell
		self.hidden = hidden
	}
}


public class SpecialArray {
	var cells: [CellWrapper]
	var visibleCells = [CellWrapper]()
	
	static func create(cells cells: [UITableViewCell]) -> SpecialArray {
		let cellWrappers = cells.map { CellWrapper(cell: $0, hidden: false) }
		return SpecialArray(cells: cellWrappers)
	}
	
	static func createEmpty() -> SpecialArray {
		return SpecialArray(cells: [])
	}
	
	init(cells: [CellWrapper]) {
		self.cells = cells
		reloadVisibleCells()
	}
	
	func reloadVisibleCells() {
		visibleCells = cells.filter { $0.hidden == false }
	}
	
	subscript(index: Int) -> UITableViewCell {
		return visibleCells[index].cell
	}
	
	var count: Int {
		return visibleCells.count
	}
	
	func append(cell: UITableViewCell) {
		let cellWrapper = CellWrapper(cell: cell, hidden: false)
		cells.append(cellWrapper)
	}

	func appendHidden(cell: UITableViewCell) {
		let cellWrapper = CellWrapper(cell: cell, hidden: true)
		cells.append(cellWrapper)
	}
}
