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
	
	public func toggleExpandCollapse(expandedCell expandedCell: UITableViewCell) {
		guard let sectionArray = dataSource as? TableViewSectionArray else {
			SwiftyFormLog("cannot expand row. The dataSource is nil")
			return
		}
		sectionArray.toggleExpandCollapse(expandedCell: expandedCell, tableView: self)
	}
}


extension TableViewSectionArray {

	public func toggleExpandCollapse(expandedCell expandedCell: UITableViewCell, tableView: UITableView) {
		SwiftyFormLog("will expand collapse")

		// If the expanded cell already is visible then collapse it
		let whatToCollapse = WhatToCollapse.process(
			expandedCell: expandedCell,
			attemptCollapseAllOtherCells: true,
			sections: sections
		)
		print("whatToCollapse: \(whatToCollapse)")
		
		if !whatToCollapse.indexPaths.isEmpty {

			for indexPath in whatToCollapse.indexPaths {
				// TODO: clean up.. don't want to subtract by 1
				let indexPath2 = NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)
				assignDefaultColors(indexPath2)
			}
			
			tableView.beginUpdates()
			tableView.deleteRowsAtIndexPaths(whatToCollapse.indexPaths, withRowAnimation: .Fade)
			tableView.endUpdates()
		}
		
		// If the expanded cell is hidden then expand it
		let whatToExpand = WhatToExpand.process(
			expandedCell: expandedCell,
			sections: sections,
			isCollapse: whatToCollapse.isCollapse
		)
		print("whatToExpand: \(whatToExpand)")

		if !whatToExpand.indexPaths.isEmpty {
			
			if let indexPath = whatToExpand.expandedIndexPath {
				// TODO: clean up.. don't want to subtract by 1
				let indexPath2 = NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)
				assignTintColors(indexPath2)
			}
			
			CATransaction.begin()
			CATransaction.setCompletionBlock({
				// Ensure that the expanded row is visible
				if let indexPath = whatToExpand.expandedIndexPath {
					// TODO: clean up.. don't want to subtract by 1
					let indexPath2 = NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)
					print("scroll to visible: \(indexPath2)")
					tableView.form_scrollToVisibleAfterExpand(indexPath2)
				}
			})

			tableView.beginUpdates()
			tableView.insertRowsAtIndexPaths(whatToExpand.indexPaths, withRowAnimation: .Fade)
			tableView.endUpdates()
			
			CATransaction.commit()
		}
		
		SwiftyFormLog("did expand collapse")
	}
	
	func assignTintColors(indexPath: NSIndexPath) {
		print("assign tint colors: \(indexPath)")
		
		guard let item = findVisibleItem(indexPath: indexPath) else {
			print("no visible cell for indexPath: \(indexPath)")
			return
		}

		if let cell = item.cell as? AssignAppearance {
			cell.assignTintColors()
		}
	}
	
	func assignDefaultColors(indexPath: NSIndexPath) {
		print("assign default colors: \(indexPath)")
		
		guard let item = findVisibleItem(indexPath: indexPath) else {
			print("no visible cell for indexPath: \(indexPath)")
			return
		}
		
		if let cell = item.cell as? AssignAppearance {
			cell.assignDefaultColors()
		}
	}
}


struct WhatToCollapse {
	let indexPaths: [NSIndexPath]
	let isCollapse: Bool
	
	static func process(expandedCell expandedCell: UITableViewCell, attemptCollapseAllOtherCells: Bool, sections: [TableViewSection]) -> WhatToCollapse {
		var indexPaths = [NSIndexPath]()
		var isCollapse = false
		
		// If the expanded cell already is visible then collapse it
		for (sectionIndex, section) in sections.enumerate() {
			for (row, item) in section.cells.visibleItems.enumerate() {
				if item.cell === expandedCell {
					item.hidden = true
					indexPaths.append(NSIndexPath(forRow: row, inSection: sectionIndex))
					isCollapse = true
					continue
				}
				if attemptCollapseAllOtherCells {
					if let expandedCell = item.cell as? DatePickerCellExpanded { // TODO: remove hardcoded type
						if let collapsedCell = expandedCell.collapsedCell {
							// If it's behavior is AlwaysExpanded, then we don't want it collapsed
							if collapsedCell.model.expandCollapseWhenSelectingRow {
								item.hidden = true
								indexPaths.append(NSIndexPath(forRow: row, inSection: sectionIndex))
							}
						}
					}
				}
			}
		}
		
		if !indexPaths.isEmpty {
			for section in sections {
				section.cells.reloadVisibleItems()
			}
		}
		return WhatToCollapse(indexPaths: indexPaths, isCollapse: isCollapse)
	}
}


struct WhatToExpand {
	let indexPaths: [NSIndexPath]
	let isExpand: Bool
	let expandedIndexPath: NSIndexPath?
	
	static func process(expandedCell expandedCell: UITableViewCell, sections: [TableViewSection], isCollapse: Bool) -> WhatToExpand {
		var indexPaths = [NSIndexPath]()
		var isExpand = false
		var expandedIndexPath: NSIndexPath?
		
		// If the expanded cell is hidden then expand it
		for (sectionIndex, section) in sections.enumerate() {
			var row = 0
			for item in section.cells.allItems {
				if !item.hidden {
					row += 1
				}
				if item.cell === expandedCell && isCollapse {
					continue
				}
				if item.cell === expandedCell {
					item.hidden = false
					let indexPath = NSIndexPath(forRow: row, inSection: sectionIndex)
					indexPaths.append(indexPath)
					isExpand = true
					expandedIndexPath = indexPath
				}
			}
		}
		if !indexPaths.isEmpty {
			for section in sections {
				section.cells.reloadVisibleItems()
			}
		}
		return WhatToExpand(indexPaths: indexPaths, isExpand: isExpand, expandedIndexPath: expandedIndexPath)
	}
}
