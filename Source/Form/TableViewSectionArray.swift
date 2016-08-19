// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class TableViewSectionArray: NSObject, UITableViewDataSource, UITableViewDelegate {
	public typealias SectionType = protocol<NSObjectProtocol, UITableViewDataSource, UITableViewDelegate>
	
	public let sections: [SectionType]
	
	public init(sections: [SectionType]) {
		self.sections = sections
		super.init()
	}
	
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
		sections[indexPath.section].tableView?(tableView, didSelectRowAtIndexPath: indexPath)
	}
	
	public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[section].tableView?(tableView, titleForHeaderInSection: section)
	}
	
	public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return sections[section].tableView?(tableView, titleForFooterInSection: section)
	}
	public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return sections[section].tableView?(tableView, viewForHeaderInSection: section)
	}
	
	public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return sections[section].tableView?(tableView, viewForFooterInSection: section)
	}
	
	public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return sections[section].tableView?(tableView, heightForHeaderInSection: section) ?? UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return sections[section].tableView?(tableView, heightForFooterInSection: section) ?? UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return sections[indexPath.section].tableView?(tableView, heightForRowAtIndexPath: indexPath) ?? 0
	}
	
	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		sections[indexPath.section].tableView?(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
	}
	
	public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		sections[indexPath.section].tableView?(tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
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
