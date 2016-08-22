// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit


public protocol ExpandedCell {
	var toggleCell: UITableViewCell? { get }
	
	// `false` when its behavior is AlwaysExpanded, in this case we don't want it collapsed
	var isCollapsable: Bool { get }
}


public struct ToggleExpandCollapse {
	public static func execute(toggleCell toggleCell: UITableViewCell, expandedCell: UITableViewCell, tableView: UITableView, sectionArray: TableViewSectionArray) {
		//SwiftyFormLog("will expand collapse")
		
		// If the expanded cell already is visible then collapse it
		let whatToCollapse = WhatToCollapse.process(
			toggleCell: toggleCell,
			expandedCell: expandedCell,
			sectionArray: sectionArray
		)
		//print("whatToCollapse: \(whatToCollapse)")
		
		if !whatToCollapse.indexPaths.isEmpty {
			
			for cell in whatToCollapse.toggleCells {
				if let cell2 = cell as? AssignAppearance {
					cell2.assignDefaultColors()
				}
			}
			
			tableView.beginUpdates()
			tableView.deleteRowsAtIndexPaths(whatToCollapse.indexPaths, withRowAnimation: .Fade)
			tableView.endUpdates()
		}
		
		// If the expanded cell is hidden then expand it
		let whatToExpand = WhatToExpand.process(
			expandedCell: expandedCell,
			sectionArray: sectionArray,
			isCollapse: whatToCollapse.isCollapse
		)
		//print("whatToExpand: \(whatToExpand)")
		
		if !whatToExpand.indexPaths.isEmpty {
			
			var toggleIndexPath: NSIndexPath?
			if let item = sectionArray.findItem(toggleCell) {
				toggleIndexPath = sectionArray.indexPathForItem(item)
			}
			
			if let cell = toggleCell as? AssignAppearance {
				cell.assignTintColors()
			}
			
			CATransaction.begin()
			CATransaction.setCompletionBlock({
				// Ensure that the toggleCell and expandedCell are visible
				if let indexPath = toggleIndexPath {
					//print("scroll to visible: \(indexPath)")
					tableView.form_scrollToVisibleAfterExpand(indexPath)
				}
			})
			
			tableView.beginUpdates()
			tableView.insertRowsAtIndexPaths(whatToExpand.indexPaths, withRowAnimation: .Fade)
			tableView.endUpdates()
			
			CATransaction.commit()
		}
		
		//SwiftyFormLog("did expand collapse")
	}
}


struct WhatToCollapse {
	let indexPaths: [NSIndexPath]
	let toggleCells: [UITableViewCell]
	let isCollapse: Bool
	
	/// If the expanded cell already is visible then collapse it
	static func process(toggleCell toggleCell: UITableViewCell, expandedCell: UITableViewCell, sectionArray: TableViewSectionArray) -> WhatToCollapse {
		var indexPaths = [NSIndexPath]()
		var toggleCells = [UITableViewCell]()
		var isCollapse = false
		
		for (sectionIndex, section) in sectionArray.sections.enumerate() {
			for (row, item) in section.cells.visibleItems.enumerate() {
				if item.cell === expandedCell {
					item.hidden = true
					indexPaths.append(NSIndexPath(forRow: row, inSection: sectionIndex))
					toggleCells.append(toggleCell)
					isCollapse = true
					continue
				}
				if let expandedCell2 = item.cell as? ExpandedCell where expandedCell2.isCollapsable {
					if let toggleCell2 = expandedCell2.toggleCell {
						item.hidden = true
						indexPaths.append(NSIndexPath(forRow: row, inSection: sectionIndex))
						toggleCells.append(toggleCell2)
					}
				}
			}
		}
		
		if !indexPaths.isEmpty {
			sectionArray.reloadVisibleItems()
		}
		return WhatToCollapse(indexPaths: indexPaths, toggleCells: toggleCells, isCollapse: isCollapse)
	}
}


struct WhatToExpand {
	let indexPaths: [NSIndexPath]
	
	/// If the expanded cell is hidden then expand it
	static func process(expandedCell expandedCell: UITableViewCell, sectionArray: TableViewSectionArray, isCollapse: Bool) -> WhatToExpand {
		
		if isCollapse {
			return WhatToExpand(indexPaths: [])
		}
		
		guard let item = sectionArray.findItem(expandedCell) else {
			return WhatToExpand(indexPaths: [])
		}
		
		if !item.hidden {
			return WhatToExpand(indexPaths: [])
		}
		
		// The expanded cell is hidden. Make it visible
		
		item.hidden = false
		sectionArray.reloadVisibleItems()
		
		guard let indexPath = sectionArray.indexPathForItem(item) else {
			print("ERROR: Expected indexPath, but got nil. At this point the item is supposed to be visible")
			return WhatToExpand(indexPaths: [])
		}
		
		return WhatToExpand(indexPaths: [indexPath])
	}
}
