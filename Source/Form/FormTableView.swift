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
	
	public func expandCollapse(expandedCell expandedCell: UITableViewCell) {
		guard let dataSource = dataSource as? TableViewSectionArray else {
			SwiftyFormLog("cannot expand row. The dataSource is nil")
			return
		}
		
		guard let sections = dataSource.sections as? [TableViewSection] else {
			print("expected all sections to be of the type TableViewSection")
			return
		}
		
		SwiftyFormLog("will expand collapse")

		// If the expanded cell already is visible then collapse it
		let whatToCollapse = WhatToCollapse.process(
			expandedCell: expandedCell,
			shouldCollapseAllOtherCells: true,
			sections: sections
		)
		print("whatToCollapse: \(whatToCollapse)")
		
		if !whatToCollapse.indexPaths.isEmpty {

			for indexPath in whatToCollapse.indexPaths {
				// TODO: clean up.. don't want to subtract by 1
				let indexPath2 = NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)
				self.assignDefaultColors(indexPath2, sections: sections)
			}
			
			beginUpdates()
			deleteRowsAtIndexPaths(whatToCollapse.indexPaths, withRowAnimation: .Fade)
			endUpdates()
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
				self.assignTintColors(indexPath2, sections: sections)
			}
			
			CATransaction.begin()
			CATransaction.setCompletionBlock({
				// Ensure that the expanded row is visible
				if let indexPath = whatToExpand.expandedIndexPath {
					// TODO: clean up.. don't want to subtract by 1
					let indexPath2 = NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)
					print("scroll to visible: \(indexPath2)")
					self.didExpand_scrollToVisible(indexPath2)
				}
			})

			beginUpdates()
			insertRowsAtIndexPaths(whatToExpand.indexPaths, withRowAnimation: .Fade)
			endUpdates()
			
			CATransaction.commit()
		}
		
		// Deselect if needed
		if let indexPath = indexPathForSelectedRow {
			beginUpdates()
			deselectRowAtIndexPath(indexPath, animated: true)
			endUpdates()
		}
		
		SwiftyFormLog("did expand collapse")
	}
	
	func lookup(indexPath indexPath: NSIndexPath, sections: [TableViewSection]) -> TableViewCellArrayItem? {
		if indexPath.section < 0 { return nil }
		if indexPath.row < 0 { return nil }
		if indexPath.section >= sections.count { return nil }
		let section = sections[indexPath.section]
		let items = section.cells.visibleItems
		if indexPath.row >= items.count { return nil }
		return items[indexPath.row]
	}
	
	func assignTintColors(indexPath: NSIndexPath, sections: [TableViewSection]) {
		print("assign tint colors: \(indexPath)")
		
		guard let item = lookup(indexPath: indexPath, sections: sections) else {
			print("no visible cell for indexPath: \(indexPath)")
			return
		}

		// TODO: remove hardcoded type DatePickerCell
		if let cell = item.cell as? DatePickerCell {
			cell.assignTintColors()
		}
	}
	
	func assignDefaultColors(indexPath: NSIndexPath, sections: [TableViewSection]) {
		print("assign default colors: \(indexPath)")
		
		guard let item = lookup(indexPath: indexPath, sections: sections) else {
			print("no visible cell for indexPath: \(indexPath)")
			return
		}
		
		// TODO: remove hardcoded type DatePickerCell
		if let cell = item.cell as? DatePickerCell {
			cell.assignDefaultColors()
		}
	}

	
	/**
	This is supposed to be run after the expand row animation has completed.
	This function ensures that the main row and its expanded row are both fully visible.
	If the rows are obscured it will scrolls to make them visible.
	*/
	private func didExpand_scrollToVisible(indexPath: NSIndexPath) {
		let rect = rectForRowAtIndexPath(indexPath)
		let focusArea_minY = rect.minY - (contentOffset.y + contentInset.top)
		//SwiftyFormLog("focusArea_minY \(focusArea_minY)    \(rect.minY) \(contentOffset.y) \(contentInset.top)")
		if focusArea_minY < 0 {
			SwiftyFormLog("focus area is outside the top. Scrolling to make it visible")
			scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
			return
		}
		
		// Expanded row
		let expanded_indexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
		let expanded_rect = rectForRowAtIndexPath(expanded_indexPath)
		let focusArea_maxY = expanded_rect.maxY - (contentOffset.y + contentInset.top)
		//SwiftyFormLog("focusArea_maxY \(focusArea_maxY)    \(expanded_rect.maxY) \(contentOffset.y) \(contentInset.top)")
		
		let bottomMaxY = bounds.height - (contentInset.bottom + contentInset.top)
		//SwiftyFormLog("bottomMaxY: \(bottomMaxY) \(bounds.height) \(contentInset.bottom) \(contentInset.top)")
		
		if focusArea_maxY > bottomMaxY {
			SwiftyFormLog("content is outside the bottom. Scrolling to make it visible")
			scrollToRowAtIndexPath(expanded_indexPath, atScrollPosition: .Bottom, animated: true)
			return
		}
		
		SwiftyFormLog("focus area is inside. No need to scroll")
	}
}


struct WhatToCollapse {
	let indexPaths: [NSIndexPath]
	let isCollapse: Bool
	
	static func process(expandedCell expandedCell: UITableViewCell, shouldCollapseAllOtherCells: Bool, sections: [TableViewSection]) -> WhatToCollapse {
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
				if shouldCollapseAllOtherCells {
					if item.cell is DatePickerCellExpanded { // TODO: remove hardcoded type
						item.hidden = true
						indexPaths.append(NSIndexPath(forRow: row, inSection: sectionIndex))
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
