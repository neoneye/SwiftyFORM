// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class TableViewSectionArray: NSObject, UITableViewDataSource, UITableViewDelegate {
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
	
	func reloadVisibleItems() {
		for section in sections {
			section.cells.reloadVisibleItems()
		}
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
		sections[indexPath.section].tableView(tableView, didSelectRowAtIndexPath: indexPath)
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
		
		if responder is DontCollapseWhenScrolling {
			// Don't collapse inline controls, such as inline date pickers, 
			// since there are more screen estate for the user to move around.
			return
		}

		// Scenario: A textfield is the first responder and has a visible keyboard
		// There is little screen estate for the user to find a button to dismiss the keyboard
		// Thus we want the keyboard to collapse when scrolling.
		responder.resignFirstResponder()
	}
	
	/// hide keyboard when the user taps the status bar
	public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
		scrollView.form_firstResponder()?.resignFirstResponder()
		return true
	}
}
