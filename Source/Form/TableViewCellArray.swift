// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class TableViewCellArrayItem {
	let cell: UITableViewCell
	var hidden: Bool
	
	init(cell: UITableViewCell, hidden: Bool) {
		self.cell = cell
		self.hidden = hidden
	}
}


public class TableViewCellArray {
	var cells: [TableViewCellArrayItem]
	var visibleCells = [TableViewCellArrayItem]()
	
	static func create(cells cells: [UITableViewCell]) -> TableViewCellArray {
		let cellWrappers = cells.map { TableViewCellArrayItem(cell: $0, hidden: false) }
		return TableViewCellArray(cells: cellWrappers)
	}
	
	static func createEmpty() -> TableViewCellArray {
		return TableViewCellArray(cells: [])
	}
	
	init(cells: [TableViewCellArrayItem]) {
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
		let cellWrapper = TableViewCellArrayItem(cell: cell, hidden: false)
		cells.append(cellWrapper)
	}

	func appendHidden(cell: UITableViewCell) {
		let cellWrapper = TableViewCellArrayItem(cell: cell, hidden: true)
		cells.append(cellWrapper)
	}
}
