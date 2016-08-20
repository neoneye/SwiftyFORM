// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public struct RowRef {
	public let item: TableViewCellArrayItem
	public let sectionArray: TableViewSectionArray
	public let tableView: UITableView
	public let indexPath: NSIndexPath
	
	func resolveIndexPath() -> NSIndexPath? {
		return sectionArray.indexPathForItem(item)
	}
}

public protocol SelectRowDelegate2 {
	func form_didSelectRow(row: RowRef)
}


extension TableViewCellArrayItem {
	func didSelectRow(sectionArray: TableViewSectionArray, _ tableView: UITableView, _ indexPath: NSIndexPath) {
		if let cell = self.cell as? SelectRowDelegate {
			cell.form_didSelectRow(indexPath, tableView: tableView)
		}
		if let cell = self.cell as? SelectRowDelegate2 {
			let row = RowRef(item: self, sectionArray: sectionArray, tableView: tableView, indexPath: indexPath)
			cell.form_didSelectRow(row)
		}
	}
}

public class TableViewSectionArray: NSObject, UITableViewDataSource, UITableViewDelegate {
	struct Constants {
		static let findVisibleItem = true
	}
	
	public let sections: [TableViewSection]
	
	public init(sections: [TableViewSection]) {
		self.sections = sections
		super.init()
	}
	
	func findItem(cell: UITableViewCell?) -> TableViewCellArrayItem? {
		for section in sections {
			for item in section.cells.allItems {
				if item.cell === cell {
					return item
				}
			}
		}
		return nil
	}
	
	func findVisibleItem(indexPath indexPath: NSIndexPath) -> TableViewCellArrayItem? {
		if indexPath.section < 0 { return nil }
		if indexPath.row < 0 { return nil }
		if indexPath.section >= sections.count { return nil }
		let section = sections[indexPath.section]
		let items = section.cells.visibleItems
		if indexPath.row >= items.count { return nil }
		return items[indexPath.row]
	}
	
	func indexPathForItem(findItem: TableViewCellArrayItem) -> NSIndexPath? {
		for (sectionIndex, section) in sections.enumerate() {
			for (rowIndex, item) in section.cells.visibleItems.enumerate() {
				if item === findItem {
					return NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
				}
			}
		}
		return nil
	}
	

	// MARK: UITableViewDataSource, UITableViewDelegate
	
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return sections.count
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].tableView(tableView, numberOfRowsInSection: section)
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return sections[indexPath.section].tableView(tableView, cellForRowAtIndexPath: indexPath)
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if Constants.findVisibleItem {
			findVisibleItem(indexPath: indexPath)?.didSelectRow(self, tableView, indexPath)
		} else {
			sections[indexPath.section].tableView(tableView, didSelectRowAtIndexPath: indexPath)
		}
	}
	
	public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[section].tableView(tableView, titleForHeaderInSection: section)
	}
	
	public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return sections[section].tableView(tableView, titleForFooterInSection: section)
	}
	
	public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return sections[section].tableView(tableView, viewForHeaderInSection: section)
	}
	
	public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return sections[section].tableView(tableView, viewForFooterInSection: section)
	}
	
	public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return sections[section].tableView(tableView, heightForHeaderInSection: section) ?? UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return sections[section].tableView(tableView, heightForFooterInSection: section) ?? UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return sections[indexPath.section].tableView(tableView, heightForRowAtIndexPath: indexPath) ?? 0
	}
	
	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		sections[indexPath.section].tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
	}
	
	public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		sections[indexPath.section].tableView(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
	}
	
	// MARK: UIScrollViewDelegate
	
	/// hide keyboard when the user starts scrolling
	public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		guard let responder = scrollView.form_firstResponder() else {
			return
		}
		
		// TODO: remove hardcoded type
		if responder is DatePickerCell {
			// We don't want our inline date picker to be collapsed when scrolling
			return
		}
		
		// Collapse the keyboard when scrolling
		responder.resignFirstResponder()
	}
	
	/// hide keyboard when the user taps the status bar
	public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
		scrollView.form_firstResponder()?.resignFirstResponder()
		return true
	}
}
