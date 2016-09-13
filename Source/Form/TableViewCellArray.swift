// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

open class TableViewCellArrayItem {
	open let cell: UITableViewCell
	open var hidden: Bool
	
	public init(cell: UITableViewCell, hidden: Bool) {
		self.cell = cell
		self.hidden = hidden
	}
}


open class TableViewCellArray {
	fileprivate(set) var allItems: [TableViewCellArrayItem]
	fileprivate(set) var visibleItems = [TableViewCellArrayItem]()
	
	open static func create(cells: [UITableViewCell]) -> TableViewCellArray {
		let items = cells.map { TableViewCellArrayItem(cell: $0, hidden: false) }
		return TableViewCellArray(allItems: items)
	}
	
	open static func createEmpty() -> TableViewCellArray {
		return TableViewCellArray(allItems: [])
	}
	
	public init(allItems: [TableViewCellArrayItem]) {
		self.allItems = allItems
		reloadVisibleItems()
	}
	
	open func reloadVisibleItems() {
		visibleItems = allItems.filter { $0.hidden == false }
	}
	
	open subscript(index: Int) -> UITableViewCell {
		return visibleItems[index].cell
	}
	
	open var count: Int {
		return visibleItems.count
	}
	
	open func append(_ cell: UITableViewCell) {
		let item = TableViewCellArrayItem(cell: cell, hidden: false)
		allItems.append(item)
	}

	open func appendHidden(_ cell: UITableViewCell) {
		let item = TableViewCellArrayItem(cell: cell, hidden: true)
		allItems.append(item)
	}
}
