// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public class FormTableView: UITableView {
	public init() {
		super.init(frame: CGRectZero, style: .Grouped)
		contentInset = UIEdgeInsetsZero
		scrollIndicatorInsets = UIEdgeInsetsZero
		estimatedRowHeight = 44.0
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	public func expandCollapse(expandedCell expandedCell: UITableViewCell, indexPath: NSIndexPath) {
		guard let dataSource = dataSource as? TableViewSectionArray else {
			SwiftyFormLog("cannot expand row. The dataSource is nil")
			return
		}
		
		if indexPath.section >= dataSource.sections.count {
			SwiftyFormLog("cannot expand row. The indexPath.section is out of range")
			return
		}
		
		guard let section = dataSource.sections[indexPath.section] as? TableViewSection else {
			SwiftyFormLog("cannot expand row. The indexPath.section has the wrong type")
			return
		}
		
		SwiftyFormLog("will expand")
		
		var insertion = [NSIndexPath]()
		var deletion = [NSIndexPath]()
		
		var row = 0
		for c in section.cells.cells {
			
			if c.cell === expandedCell {
				if c.hidden {
					c.hidden = false
					section.cells.reloadVisibleCells()
					insertion.append(NSIndexPath(forRow: row, inSection: indexPath.section))
					break
				} else {
					c.hidden = true
					section.cells.reloadVisibleCells()
					deletion.append(NSIndexPath(forRow: row, inSection: indexPath.section))
				}
			}
			
			if c.hidden {
				continue
			}
			row += 1
		}
		
		beginUpdates()
		deleteRowsAtIndexPaths(deletion, withRowAnimation: .Fade)
		insertRowsAtIndexPaths(insertion, withRowAnimation: .Fade)
		if let indexPath = indexPathForSelectedRow {
			deselectRowAtIndexPath(indexPath, animated: true)
		}
		endUpdates()
		
		SwiftyFormLog("did expand")
	}
}
