// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

/// Adjusts bottom insets when keyboard is shown and makes sure the keyboard doesn't obscure the cell
/// Resets insets when the keyboard is hidden
public class KeyboardHandler: NSObject {
	private let tableView: UITableView
	private var innerKeyboardVisible: Bool = false
	
	init(tableView: UITableView) {
		self.tableView = tableView
	}
	
	var keyboardVisible: Bool {
		get { return innerKeyboardVisible }
	}

	func addObservers() {
		/*
		I listen to UIKeyboardWillShowNotification.
		I don't listen to UIKeyboardWillChangeFrameNotification
		
		Explanation:
		UIKeyboardWillChangeFrameNotification vs. UIKeyboardWillShowNotification
		
		The notifications behave the same on iPhone.
		However there is a big difference on iPad.
		
		On iPad with a split keyboard or a non-docked keyboard.
		When you make a textfield first responder and the keyboard appears,
		then UIKeyboardWillShowNotification is not invoked.
		only UIKeyboardWillChangeFrameNotification is invoked.
		
		The user has chosen actively to manually position the keyboard.
		In this case it's non-trivial to scroll to the textfield.
		It's not something I will support for now.
		*/
		
		// Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
		let notificationCenter = NSNotificationCenter.defaultCenter()
		notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
		notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func removeObservers() {
		let notificationCenter = NSNotificationCenter.defaultCenter()
		notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func keyboardWillShow(notification: NSNotification) {
//		DLog("show\n\n\n\n\n\n\n\n")
		innerKeyboardVisible = true
		let cellOrNil = tableView.form_firstResponder()?.form_cell()
		if cellOrNil == nil {
			return
		}
		let cell = cellOrNil!
		
		let indexPathOrNil = tableView.indexPathForCell(cell)
		if indexPathOrNil == nil {
			return
		}
		let indexPath = indexPathOrNil!
		
		let rectForRow = tableView.rectForRowAtIndexPath(indexPath)
//		DLog("rectForRow \(NSStringFromCGRect(rectForRow))")
		
		let userInfoOrNil: [NSObject : AnyObject]? = notification.userInfo
		if userInfoOrNil == nil {
			return
		}
		let userInfo = userInfoOrNil!

		let windowOrNil: UIWindow? = tableView.window
		if windowOrNil == nil {
			return
		}
		let window = windowOrNil!

		let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//		DLog("keyboardFrameEnd \(NSStringFromCGRect(keyboardFrameEnd))")
		
		
		let keyboardFrame = window.convertRect(keyboardFrameEnd, toView: tableView.superview)
//		DLog("keyboardFrame \(keyboardFrame)")
		
		let convertedRectForRow = window.convertRect(rectForRow, fromView: tableView)
//		DLog("convertedRectForRow \(NSStringFromCGRect(convertedRectForRow))")
		
//		DLog("tableView.frame \(NSStringFromCGRect(tableView.frame))")
		
		var scrollToVisible = false
		var scrollToRect = CGRectZero

		let spaceBetweenCellAndKeyboard: CGFloat = 36
		let y0 = CGRectGetMaxY(convertedRectForRow) + spaceBetweenCellAndKeyboard
		let y1 = CGRectGetMinY(keyboardFrameEnd)
		let obscured = y0 > y1
//		DLog("values \(y0) \(y1) \(obscured)")
		if obscured {
			DLog("cell is obscured by keyboard, we are scrolling")
			scrollToVisible = true
			scrollToRect = rectForRow
			scrollToRect.size.height += spaceBetweenCellAndKeyboard
		} else {
			DLog("cell is fully visible, no need to scroll")
		}
		let inset: CGFloat = tableView.frame.origin.y + tableView.frame.size.height - keyboardFrame.origin.y
		//DLog("inset \(inset)")
		
		var contentInset: UIEdgeInsets = tableView.contentInset
		var scrollIndicatorInsets: UIEdgeInsets = tableView.scrollIndicatorInsets

		contentInset.bottom = inset
		scrollIndicatorInsets.bottom = inset
		
		// Adjust insets and scroll to the selected row
		tableView.contentInset = contentInset
		tableView.scrollIndicatorInsets = scrollIndicatorInsets
		if scrollToVisible {
			tableView.scrollRectToVisible(scrollToRect, animated: false)
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
//		DLog("\n\n\n\nhide")
		innerKeyboardVisible = false
		
		var contentInset: UIEdgeInsets = tableView.contentInset
		var scrollIndicatorInsets: UIEdgeInsets = tableView.scrollIndicatorInsets
		
		contentInset.bottom = 0
		scrollIndicatorInsets.bottom = 0
		
//		DLog("contentInset \(NSStringFromUIEdgeInsets(contentInset))")
//		DLog("scrollIndicatorInsets \(NSStringFromUIEdgeInsets(scrollIndicatorInsets))")
		
		// Restore insets
		tableView.contentInset = contentInset
		tableView.scrollIndicatorInsets = scrollIndicatorInsets
	}

}
