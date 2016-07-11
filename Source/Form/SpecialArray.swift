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
	let cells: [CellWrapper]
	var visibleCells = [CellWrapper]()
	
	static func create(cells cells: [UITableViewCell]) -> SpecialArray {
		let cellWrappers = cells.map { CellWrapper(cell: $0, hidden: false) }
		return SpecialArray(cells: cellWrappers)
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
}
