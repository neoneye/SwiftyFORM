// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class TableViewSection: NSObject, UITableViewDataSource, UITableViewDelegate {
	public let cells: TableViewCellArray
	fileprivate let headerBlock: TableViewSectionPart.CreateBlock
	fileprivate let footerBlock: TableViewSectionPart.CreateBlock
	
	init(cells: TableViewCellArray, headerBlock: @escaping TableViewSectionPart.CreateBlock, footerBlock: @escaping TableViewSectionPart.CreateBlock) {
		self.cells = cells
		self.headerBlock = headerBlock
		self.footerBlock = footerBlock
		super.init()
	}

	fileprivate lazy var header: TableViewSectionPart = {
		return self.headerBlock()
		}()

	fileprivate lazy var footer: TableViewSectionPart = {
		return self.footerBlock()
		}()

	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cells.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = cells[(indexPath as NSIndexPath).row]
		if let theCell = cell as? CellForRowDelegate {
			return theCell.form_cellForRow(indexPath, tableView: tableView)
		}
		return cell
	}
	
	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return header.title
	}
	
	public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return footer.title
	}

	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return header.view
	}

	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return footer.view
	}

	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return header.height
	}
	
	public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return footer.height
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = cells[(indexPath as NSIndexPath).row] as? SelectRowDelegate {
			cell.form_didSelectRow(indexPath, tableView: tableView)
		}
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let cell = cells[(indexPath as NSIndexPath).row] as? CellHeightProvider {
			return cell.form_cellHeight(indexPath: indexPath, tableView: tableView)
		}
		return UITableViewAutomaticDimension
	}
	
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cells[(indexPath as NSIndexPath).row] as? WillDisplayCellDelegate {
			cell.form_willDisplay(tableView, forRowAtIndexPath: indexPath)
		}
	}
	
	public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		if let cell = cells[(indexPath as NSIndexPath).row] as? AccessoryButtonDelegate {
			cell.form_accessoryButtonTapped(indexPath, tableView: tableView)
		}
	}
}
