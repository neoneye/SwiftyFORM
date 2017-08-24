// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

public extension IndexPath {

	/// Indexpath of the previous cell.
	///
	/// This function is complex because it deals with empty sections and invalid indexpaths.
	public func form_indexPathForPreviousCell(_ tableView: UITableView) -> IndexPath? {
		if section < 0 || row < 0 {
			return nil
		}
		let sectionCount = tableView.numberOfSections
		if section < 0 || section >= sectionCount {
			return nil
		}
		let firstRowCount = tableView.numberOfRows(inSection: section)
		if row > 0 && row <= firstRowCount {
			return IndexPath(row: row - 1, section: section)
		}
		var currentSection = section
		while true {
			currentSection -= 1
			if currentSection < 0 || currentSection >= sectionCount {
				return nil
			}
			let rowCount = tableView.numberOfRows(inSection: currentSection)
			if rowCount > 0 {
				return IndexPath(row: rowCount - 1, section: currentSection)
			}
		}
	}

	/// Indexpath of the next cell.
	///
	/// This function is complex because it deals with empty sections and invalid indexpaths.
	public func form_indexPathForNextCell(_ tableView: UITableView) -> IndexPath? {
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
			let rowCount = tableView.numberOfRows(inSection: currentSection)
			if currentRow >= 0 && currentRow < rowCount {
				return IndexPath(row: currentRow, section: currentSection)
			}
			if currentRow > rowCount {
				return nil
			}
			currentSection += 1
			currentRow = 0
		}
	}

}

extension UITableView {

	/// Determine where a cell is located in this tableview. Considers cells inside and cells outside the visible area.
	///
	/// Unlike UITableView.indexPathForCell() which only looksup inside the visible area.
	/// UITableView doesn't let you lookup cells outside the visible area.
	/// UITableView.indexPathForCell() returns nil when the cell is outside the visible area.
	func form_indexPathForCell(_ cell: UITableViewCell) -> IndexPath? {
		guard let dataSource = self.dataSource else { return nil }
		let sectionCount: Int = dataSource.numberOfSections?(in: self) ?? 0
		for section: Int in 0 ..< sectionCount {
			let rowCount: Int = dataSource.tableView(self, numberOfRowsInSection: section)
			for row: Int in 0 ..< rowCount {
				let indexPath = IndexPath(row: row, section: section)
				let dataSourceCell = dataSource.tableView(self, cellForRowAt: indexPath)
				if dataSourceCell === cell {
					return indexPath
				}
			}
		}
		return nil
	}

	/// Find a cell above that can be jumped to. Skip cells that cannot be jumped to.
	///
	/// Usage: when the user types SHIFT TAB on the keyboard, then we want to jump to a cell above.
	func form_indexPathForPreviousResponder(_ initialIndexPath: IndexPath) -> IndexPath? {
		guard let dataSource = self.dataSource else { return nil }
		var indexPath: IndexPath! = initialIndexPath
		while true {
			indexPath = indexPath.form_indexPathForPreviousCell(self)
			if indexPath == nil {
				return nil
			}

			let cell = dataSource.tableView(self, cellForRowAt: indexPath)
			if cell.canBecomeFirstResponder {
				return indexPath
			}
		}
	}

	/// Find a cell below that can be jumped to. Skip cells that cannot be jumped to.
	///
	/// Usage: when the user hits TAB on the keyboard, then we want to jump to a cell below.
	func form_indexPathForNextResponder(_ initialIndexPath: IndexPath) -> IndexPath? {
		guard let dataSource = self.dataSource else { return nil }
		var indexPath: IndexPath! = initialIndexPath
		while true {
			indexPath = indexPath.form_indexPathForNextCell(self)
			if indexPath == nil {
				return nil
			}

			let cell = dataSource.tableView(self, cellForRowAt: indexPath)
			if cell.canBecomeFirstResponder {
				return indexPath
			}
		}
	}

	/// Jump to a cell above.
	///
	/// Usage: when the user types SHIFT TAB on the keyboard, then we want to jump to a cell above.
	func form_makePreviousCellFirstResponder(_ cell: UITableViewCell) {
		guard let indexPath0 = form_indexPathForCell(cell) else { return }
		guard let indexPath1 = form_indexPathForPreviousResponder(indexPath0) else { return }
		guard let dataSource = self.dataSource else { return }
		scrollToRow(at: indexPath1, at: .middle, animated: true)
		let cell = dataSource.tableView(self, cellForRowAt: indexPath1)
		cell.becomeFirstResponder()
	}

	/// Jump to a cell below.
	///
	/// Usage: when the user hits TAB on the keyboard, then we want to jump to a cell below.
	func form_makeNextCellFirstResponder(_ cell: UITableViewCell) {
		guard let indexPath0 = form_indexPathForCell(cell) else { return }
		guard let indexPath1 = form_indexPathForNextResponder(indexPath0) else { return }
		guard let dataSource = self.dataSource else { return }
		scrollToRow(at: indexPath1, at: .middle, animated: true)
		let cell = dataSource.tableView(self, cellForRowAt: indexPath1)
		cell.becomeFirstResponder()
	}

	/// Determines if it's possible to jump to a cell above.
	func form_canMakePreviousCellFirstResponder(_ cell: UITableViewCell) -> Bool {
		guard let indexPath0 = form_indexPathForCell(cell) else { return false }
		if form_indexPathForPreviousResponder(indexPath0) == nil { return false }
		if self.dataSource == nil { return false }
		return true
	}

	/// Determines if it's possible to jump to a cell below.
	func form_canMakeNextCellFirstResponder(_ cell: UITableViewCell) -> Bool {
		guard let indexPath0 = form_indexPathForCell(cell) else { return false }
		if form_indexPathForNextResponder(indexPath0) == nil { return false }
		if self.dataSource == nil { return false }
		return true
	}
}

extension UITableViewCell {

	/// Jump to the previous cell, located above the current cell.
	///
	/// Usage: when the user types SHIFT TAB on the keyboard, then we want to jump to a cell above.
	func form_makePreviousCellFirstResponder() {
		form_tableView()?.form_makePreviousCellFirstResponder(self)
	}

	/// Jump to the next cell, located below the current cell.
	///
	/// Usage: when the user hits TAB on the keyboard, then we want to jump to a cell below.
	func form_makeNextCellFirstResponder() {
		form_tableView()?.form_makeNextCellFirstResponder(self)
	}

	/// Determines if it's possible to jump to the cell above.
	func form_canMakePreviousCellFirstResponder() -> Bool {
		return form_tableView()?.form_canMakePreviousCellFirstResponder(self) ?? false
	}

	/// Determines if it's possible to jump to the cell below.
	func form_canMakeNextCellFirstResponder() -> Bool {
		return form_tableView()?.form_canMakeNextCellFirstResponder(self) ?? false
	}
}
