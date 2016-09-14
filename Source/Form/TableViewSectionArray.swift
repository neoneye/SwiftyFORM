// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class TableViewSectionArray: NSObject, UITableViewDataSource, UITableViewDelegate {
	public let sections: [TableViewSection]
	
	public init(sections: [TableViewSection]) {
		self.sections = sections
		super.init()
	}
	
	func findItem(_ cell: UITableViewCell?) -> TableViewCellArrayItem? {
		for section in sections {
			for item in section.cells.allItems {
				if item.cell === cell {
					return item
				}
			}
		}
		return nil
	}
	
	func findVisibleItem(indexPath: IndexPath) -> TableViewCellArrayItem? {
		if (indexPath as NSIndexPath).section < 0 { return nil }
		if (indexPath as NSIndexPath).row < 0 { return nil }
		if (indexPath as NSIndexPath).section >= sections.count { return nil }
		let section = sections[(indexPath as NSIndexPath).section]
		let items = section.cells.visibleItems
		if (indexPath as NSIndexPath).row >= items.count { return nil }
		return items[(indexPath as NSIndexPath).row]
	}
	
	func indexPathForItem(_ findItem: TableViewCellArrayItem) -> IndexPath? {
		for (sectionIndex, section) in sections.enumerated() {
			for (rowIndex, item) in section.cells.visibleItems.enumerated() {
				if item === findItem {
					return IndexPath(row: rowIndex, section: sectionIndex)
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
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].tableView(tableView, numberOfRowsInSection: section)
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return sections[(indexPath as NSIndexPath).section].tableView(tableView, cellForRowAt: indexPath)
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		sections[(indexPath as NSIndexPath).section].tableView(tableView, didSelectRowAt: indexPath)
	}
	
	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[section].tableView(tableView, titleForHeaderInSection: section)
	}
	
	public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return sections[section].tableView(tableView, titleForFooterInSection: section)
	}
	
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return sections[section].tableView(tableView, viewForHeaderInSection: section)
	}
	
	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return sections[section].tableView(tableView, viewForFooterInSection: section)
	}
	
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return sections[section].tableView(tableView, heightForHeaderInSection: section)
	}
	
	public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return sections[section].tableView(tableView, heightForFooterInSection: section)
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return sections[(indexPath as NSIndexPath).section].tableView(tableView, heightForRowAt: indexPath)
	}
	
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		sections[(indexPath as NSIndexPath).section].tableView(tableView, willDisplay: cell, forRowAt: indexPath)
	}
	
	public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		sections[(indexPath as NSIndexPath).section].tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
	}
	
	// MARK: UIScrollViewDelegate
	
	/// hide keyboard when the user starts scrolling
	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
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
	public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		scrollView.form_firstResponder()?.resignFirstResponder()
		return true
	}
}
