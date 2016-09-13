// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

open class TableViewSection: NSObject, UITableViewDataSource, UITableViewDelegate {
	open let cells: TableViewCellArray
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

	
	open func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cells.count
	}
	
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = cells[(indexPath as NSIndexPath).row]
		if let theCell = cell as? CellForRowDelegate {
			return theCell.form_cellForRow(indexPath, tableView: tableView)
		}
		return cell
	}
	
	open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return header.title
	}
	
	open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return footer.title
	}

	open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return header.view
	}

	open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return footer.view
	}

	open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return header.height
	}
	
	open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return footer.height
	}
	
	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = cells[(indexPath as NSIndexPath).row] as? SelectRowDelegate {
			cell.form_didSelectRow(indexPath, tableView: tableView)
		}
	}
	
	open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let cell = cells[(indexPath as NSIndexPath).row] as? CellHeightProvider {
			return cell.form_cellHeight(indexPath, tableView: tableView)
		}
		return UITableViewAutomaticDimension
	}
	
	open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cells[(indexPath as NSIndexPath).row] as? WillDisplayCellDelegate {
			cell.form_willDisplay(tableView, forRowAtIndexPath: indexPath)
		}
	}
	
	open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		if let cell = cells[(indexPath as NSIndexPath).row] as? AccessoryButtonDelegate {
			cell.form_accessoryButtonTapped(indexPath, tableView: tableView)
		}
	}
}
