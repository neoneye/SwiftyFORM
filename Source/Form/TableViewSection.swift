// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class TableViewSection: NSObject, UITableViewDataSource, UITableViewDelegate {
	public let cells: TableViewCellArray
	private let header: TableViewSectionPart
	private let footer: TableViewSectionPart
	
	init(cells: TableViewCellArray, header: TableViewSectionPart, footer: TableViewSectionPart) {
		self.cells = cells
		self.header = header
		self.footer = footer
		super.init()
	}
	
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
	
	public func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		switch header {
		case .None:
			return 2
		case .Default:
			return 44
		case let .TitleView(view):
			let view2: UIView = view
			return view2.frame.size.height
		case .TitleString(_):
			return 44
		}
	}
	
	// TODO: estimatedHeightForFooterInSection

	
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
