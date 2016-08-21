// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

extension UITableView {
	/**
	This is supposed to be run after the expand row animation has completed.
	This function ensures that the main row and its expanded row are both fully visible.
	If the rows are obscured it will scrolls to make them visible.
	*/
	internal func form_scrollToVisibleAfterExpand(indexPath: NSIndexPath) {
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
