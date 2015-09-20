// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public extension NSIndexPath {
	
	/**
	Indexpath of the previous cell.
	
	This function is complex because it deals with empty sections and invalid indexpaths.
	*/
	public func form_indexPathForPreviousCell(tableView: UITableView) -> NSIndexPath? {
		if section < 0 || row < 0 {
			return nil
		}
		let sectionCount = tableView.numberOfSections
		if section < 0 || section >= sectionCount {
			return nil
		}
		let firstRowCount = tableView.numberOfRowsInSection(section)
		if row > 0 && row <= firstRowCount {
			return NSIndexPath(forRow: row - 1, inSection: section)
		}
		var currentSection = section
		while true {
			currentSection--
			if currentSection < 0 || currentSection >= sectionCount {
				return nil
			}
			let rowCount = tableView.numberOfRowsInSection(currentSection)
			if rowCount > 0 {
				return NSIndexPath(forRow: rowCount - 1, inSection: currentSection)
			}
		}
	}
	
	/**
	Indexpath of the next cell.
	
	This function is complex because it deals with empty sections and invalid indexpaths.
	*/
	public func form_indexPathForNextCell(tableView: UITableView) -> NSIndexPath? {
		if section < 0 {
			return nil
		}
		let sectionCount = tableView.numberOfSections
		var currentRow = row + 1
		var currentSection = section
		while true {
			if currentSection >= sectionCount {
				return nil
			}
			let rowCount = tableView.numberOfRowsInSection(currentSection)
			if currentRow >= 0 && currentRow < rowCount {
				return NSIndexPath(forRow: currentRow, inSection: currentSection)
			}
			if currentRow > rowCount {
				return nil
			}
			currentSection++
			currentRow = 0
		}
	}
	
}


extension UITableView {
	
	/**
	Determine where a cell is located in this tableview. Considers cells inside and cells outside the visible area.
	
	Unlike UITableView.indexPathForCell() which only looksup inside the visible area.
	UITableView doesn't let you lookup cells outside the visible area.
	UITableView.indexPathForCell() returns nil when the cell is outside the visible area.
	*/
	func form_indexPathForCell(cell: UITableViewCell) -> NSIndexPath? {
		guard let dataSource = self.dataSource else { return nil }
		let sectionCount: Int = dataSource.numberOfSectionsInTableView?(self) ?? 0
		for var section: Int = 0; section < sectionCount; section++ {
			let rowCount: Int = dataSource.tableView(self, numberOfRowsInSection: section)
			for var row: Int = 0; row < rowCount; row++ {
				let indexPath = NSIndexPath(forRow: row, inSection: section)
				let dataSourceCell = dataSource.tableView(self, cellForRowAtIndexPath: indexPath)
				if dataSourceCell === cell {
					return indexPath
				}
			}
		}
		return nil
	}

	/**
	Find a cell above that can be jumped to. Skip cells that cannot be jumped to.
	
	Usage: when the user types SHIFT TAB on the keyboard, then we want to jump to a cell above.
	*/
	func form_indexPathForPreviousResponder(initialIndexPath: NSIndexPath) -> NSIndexPath? {
		guard let dataSource = self.dataSource else { return nil }
		var indexPath: NSIndexPath! = initialIndexPath
		while true {
			indexPath = indexPath.form_indexPathForPreviousCell(self)
			if indexPath == nil {
				return nil
			}

			let cell = dataSource.tableView(self, cellForRowAtIndexPath: indexPath)
			if cell.canBecomeFirstResponder() {
				return indexPath
			}
		}
	}
			
	/**
	Find a cell below that can be jumped to. Skip cells that cannot be jumped to.
	
	Usage: when the user hits TAB on the keyboard, then we want to jump to a cell below.
	*/
	func form_indexPathForNextResponder(initialIndexPath: NSIndexPath) -> NSIndexPath? {
		guard let dataSource = self.dataSource else { return nil }
		var indexPath: NSIndexPath! = initialIndexPath
		while true {
			indexPath = indexPath.form_indexPathForNextCell(self)
			if indexPath == nil {
				return nil
			}
			
			let cell = dataSource.tableView(self, cellForRowAtIndexPath: indexPath)
			if cell.canBecomeFirstResponder() {
				return indexPath
			}
		}
	}
	
	/**
	Jump to a cell above.
	
	Usage: when the user types SHIFT TAB on the keyboard, then we want to jump to a cell above.
	*/
	func form_makePreviousCellFirstResponder(cell: UITableViewCell) {
		guard let indexPath0 = form_indexPathForCell(cell) else { return }
		guard let indexPath1 = form_indexPathForPreviousResponder(indexPath0) else { return }
		guard let dataSource = self.dataSource else { return }
		scrollToRowAtIndexPath(indexPath1, atScrollPosition: .Middle, animated: true)
		let cell = dataSource.tableView(self, cellForRowAtIndexPath: indexPath1)
		cell.becomeFirstResponder()
	}
	
	/**
	Jump to a cell below.
	
	Usage: when the user hits TAB on the keyboard, then we want to jump to a cell below.
	*/
	func form_makeNextCellFirstResponder(cell: UITableViewCell) {
		guard let indexPath0 = form_indexPathForCell(cell) else { return }
		guard let indexPath1 = form_indexPathForNextResponder(indexPath0) else { return }
		guard let dataSource = self.dataSource else { return }
		scrollToRowAtIndexPath(indexPath1, atScrollPosition: .Middle, animated: true)
		let cell = dataSource.tableView(self, cellForRowAtIndexPath: indexPath1)
		cell.becomeFirstResponder()
	}

	/**
	Determines if it's possible to jump to a cell above.
	*/
	func form_canMakePreviousCellFirstResponder(cell: UITableViewCell) -> Bool {
		guard let indexPath0 = form_indexPathForCell(cell) else { return false }
		if form_indexPathForPreviousResponder(indexPath0) == nil { return false }
		if self.dataSource == nil { return false }
		return true
	}

	/**
	Determines if it's possible to jump to a cell below.
	*/
	func form_canMakeNextCellFirstResponder(cell: UITableViewCell) -> Bool {
		guard let indexPath0 = form_indexPathForCell(cell) else { return false }
		if form_indexPathForNextResponder(indexPath0) == nil { return false }
		if self.dataSource == nil { return false }
		return true
	}
}


extension UITableViewCell {
	
	/**
	Jump to the previous cell, located above the current cell.
	
	Usage: when the user types SHIFT TAB on the keyboard, then we want to jump to a cell above.
	*/
	func form_makePreviousCellFirstResponder() {
		form_tableView()?.form_makePreviousCellFirstResponder(self)
	}

	/**
	Jump to the next cell, located below the current cell.
	
	Usage: when the user hits TAB on the keyboard, then we want to jump to a cell below.
	*/
	func form_makeNextCellFirstResponder() {
		form_tableView()?.form_makeNextCellFirstResponder(self)
	}
	
	/**
	Determines if it's possible to jump to the cell above.
	*/
	func form_canMakePreviousCellFirstResponder() -> Bool {
		return form_tableView()?.form_canMakePreviousCellFirstResponder(self) ?? false
	}
	
	/**
	Determines if it's possible to jump to the cell below.
	*/
	func form_canMakeNextCellFirstResponder() -> Bool {
		return form_tableView()?.form_canMakeNextCellFirstResponder(self) ?? false
	}

	
}