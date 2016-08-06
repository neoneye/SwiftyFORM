// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public enum TableViewSectionPart {
	case None
	case TitleString(string: String)
	case TitleView(view: UIView)
	
	typealias CreateBlock = Void -> TableViewSectionPart
	
	var title: String? {
		switch self {
		case let .TitleString(string):
			return string
		default:
			return nil
		}
	}

	var view: UIView? {
		switch self {
		case let .TitleView(view):
			return view
		default:
			return nil
		}
	}
	
	var height: CGFloat {
		switch self {
		case let .TitleView(view):
			let view2: UIView = view
			return view2.frame.size.height
		default:
			return UITableViewAutomaticDimension
		}
	}
}

public class TableViewSection : NSObject, UITableViewDataSource, UITableViewDelegate {
	public let cells: TableViewCellArray
	private let headerBlock: TableViewSectionPart.CreateBlock
	private let footerBlock: TableViewSectionPart.CreateBlock
	
	init(cells: TableViewCellArray, headerBlock: TableViewSectionPart.CreateBlock, footerBlock: TableViewSectionPart.CreateBlock) {
		self.cells = cells
		self.headerBlock = headerBlock
		self.footerBlock = footerBlock
		super.init()
	}

	private lazy var header: TableViewSectionPart = {
		return self.headerBlock()
		}()

	private lazy var footer: TableViewSectionPart = {
		return self.footerBlock()
		}()

	
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cells.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = cells[indexPath.row]
		if let theCell = cell as? CellForRowDelegate {
			return theCell.form_cellForRow(indexPath, tableView: tableView)
		}
		return cell
	}
	
	public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return header.title
	}
	
	public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return footer.title
	}

	public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return header.view
	}

	public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return footer.view
	}

	public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return header.height
	}
	
	public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return footer.height
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let cell = cells[indexPath.row] as? SelectRowDelegate {
			cell.form_didSelectRow(indexPath, tableView: tableView)
		}
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if let cell = cells[indexPath.row] as? CellHeightProvider {
			return cell.form_cellHeight(indexPath, tableView: tableView)
		}
		return UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if let cell = cells[indexPath.row] as? WillDisplayCellDelegate {
			cell.form_willDisplay(tableView, forRowAtIndexPath: indexPath)
		}
	}
	
	public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		if let cell = cells[indexPath.row] as? AccessoryButtonDelegate {
			cell.form_accessoryButtonTapped(indexPath, tableView: tableView)
		}
	}
}


/// UITableView with multiple sections
public class TableViewSectionArray : NSObject, UITableViewDataSource, UITableViewDelegate {
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
		scrollView.form_firstResponder()?.resignFirstResponder()
	}
	
	/// hide keyboard when the user taps the status bar
	public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
		scrollView.form_firstResponder()?.resignFirstResponder()
		return true
	}
}

