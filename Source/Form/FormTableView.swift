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
		
		var isExpand = false
		var isCollapse = false
		
		var row = 0
		for item in section.cells.allItems {
			
			if item.cell === expandedCell {
				if item.hidden {
					item.hidden = false
					section.cells.reloadVisibleItems()
					insertion.append(NSIndexPath(forRow: row, inSection: indexPath.section))
					isExpand = true
					break
				} else {
					item.hidden = true
					section.cells.reloadVisibleItems()
					deletion.append(NSIndexPath(forRow: row, inSection: indexPath.section))
					isCollapse = true
				}
			}
			
			if item.hidden {
				continue
			}
			row += 1
		}
		
		CATransaction.begin()
		CATransaction.setCompletionBlock({
			if isExpand {
				self.didExpand_scrollToVisible(indexPath)
			}
			if isCollapse {
				self.didCollapse_scrollToVisible(indexPath)
			}
		})
		
		beginUpdates()
		deleteRowsAtIndexPaths(deletion, withRowAnimation: .Fade)
		insertRowsAtIndexPaths(insertion, withRowAnimation: .Fade)
		if let indexPath = indexPathForSelectedRow {
			deselectRowAtIndexPath(indexPath, animated: true)
		}
		endUpdates()
		
		CATransaction.commit()
		
		SwiftyFormLog("did expand")
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

	/**
	This is supposed to be run after the collapse row animation has completed.
	This function ensures that the collapsed row is fully visible.
	If the row is obscured it will scroll to make the row visible.
	*/
	private func didCollapse_scrollToVisible(indexPath: NSIndexPath) {
		let rect = rectForRowAtIndexPath(indexPath)
		let focusArea_minY = rect.minY - (contentOffset.y + contentInset.top)
		//SwiftyFormLog("focusArea_minY \(focusArea_minY)    \(rect.minY) \(contentOffset.y) \(contentInset.top)")
		
		if focusArea_minY < 0 {
			SwiftyFormLog("focus area is outside the top. Scrolling to make it visible")
			scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
			return
		}
		
		let focusArea_maxY = rect.maxY - (contentOffset.y + contentInset.top)
		//SwiftyFormLog("focusArea_maxY \(focusArea_maxY)    \(rect.maxY) \(contentOffset.y) \(contentInset.top)")
		
		let bottomMaxY = bounds.height - (contentInset.bottom + contentInset.top)
		//SwiftyFormLog("bottomMaxY: \(bottomMaxY) \(bounds.height) \(contentInset.bottom) \(contentInset.top)")
		
		if focusArea_maxY > bottomMaxY {
			SwiftyFormLog("content is outside the bottom. Scrolling to make it visible")
			scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
			return
		}
		
		SwiftyFormLog("focus area is inside. No need to scroll")
	}
}
