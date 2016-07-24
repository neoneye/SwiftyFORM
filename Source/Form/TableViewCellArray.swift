// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class TableViewCellArrayItem {
	public let cell: UITableViewCell
	public var hidden: Bool
	
	public init(cell: UITableViewCell, hidden: Bool) {
		self.cell = cell
		self.hidden = hidden
	}
}


public class TableViewCellArray {
	private(set) var allItems: [TableViewCellArrayItem]
	private(set) var visibleItems = [TableViewCellArrayItem]()
	
	public static func create(cells cells: [UITableViewCell]) -> TableViewCellArray {
		let items = cells.map { TableViewCellArrayItem(cell: $0, hidden: false) }
		return TableViewCellArray(allItems: items)
	}
	
	public static func createEmpty() -> TableViewCellArray {
		return TableViewCellArray(allItems: [])
	}
	
	public init(allItems: [TableViewCellArrayItem]) {
		self.allItems = allItems
		reloadVisibleItems()
	}
	
	public func reloadVisibleItems() {
		visibleItems = allItems.filter { $0.hidden == false }
	}
	
	public subscript(index: Int) -> UITableViewCell {
		return visibleItems[index].cell
	}
	
	public var count: Int {
		return visibleItems.count
	}
	
	public func append(cell: UITableViewCell) {
		let item = TableViewCellArrayItem(cell: cell, hidden: false)
		allItems.append(item)
	}

	public func appendHidden(cell: UITableViewCell) {
		let item = TableViewCellArrayItem(cell: cell, hidden: true)
		allItems.append(item)
	}
}
