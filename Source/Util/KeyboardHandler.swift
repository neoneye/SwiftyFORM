// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

/// Adjusts bottom insets when keyboard is shown and makes sure the keyboard doesn't obscure the cell.
///
/// Resets insets when the keyboard is hidden.
public class KeyboardHandler {
	private let tableView: UITableView
	private var innerKeyboardVisible: Bool = false

	init(tableView: UITableView) {
		self.tableView = tableView
	}

	var keyboardVisible: Bool {
		return innerKeyboardVisible
	}

	/// Start listening for changes to keyboard visibility so that we can adjust the scroll view accordingly.
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

		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(KeyboardHandler.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		notificationCenter.addObserver(self, selector: #selector(KeyboardHandler.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}

	/// Stop listening to keyboard visibility changes
	func removeObservers() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}

	/// The keyboard will appear, scroll content so it's not covered by the keyboard.
	@objc func keyboardWillShow(_ notification: Notification) {
//		SwiftyFormLog("show\n\n\n\n\n\n\n\n")
		innerKeyboardVisible = true
		guard let cell = tableView.form_firstResponder()?.form_cell() else {
			return
		}
		guard let indexPath = tableView.indexPath(for: cell) else {
			return
		}

		let rectForRow = tableView.rectForRow(at: indexPath)
//		SwiftyFormLog("rectForRow \(NSStringFromCGRect(rectForRow))")

		guard let userInfo: [AnyHashable: Any] = notification.userInfo else {
			return
		}
		guard let window: UIWindow = tableView.window else {
			return
		}

		let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//		SwiftyFormLog("keyboardFrameEnd \(NSStringFromCGRect(keyboardFrameEnd))")

		let keyboardFrame = window.convert(keyboardFrameEnd, to: tableView.superview)
//		SwiftyFormLog("keyboardFrame \(keyboardFrame)")

		let convertedRectForRow = window.convert(rectForRow, from: tableView)
//		SwiftyFormLog("convertedRectForRow \(NSStringFromCGRect(convertedRectForRow))")

//		SwiftyFormLog("tableView.frame \(NSStringFromCGRect(tableView.frame))")

		var scrollToVisible = false
		var scrollToRect = CGRect.zero

		let spaceBetweenCellAndKeyboard: CGFloat = 36
		let y0 = convertedRectForRow.maxY + spaceBetweenCellAndKeyboard
		let y1 = keyboardFrameEnd.minY
		let obscured = y0 > y1
//		SwiftyFormLog("values \(y0) \(y1) \(obscured)")
		if obscured {
			SwiftyFormLog("cell is obscured by keyboard, we are scrolling")
			scrollToVisible = true
			scrollToRect = rectForRow
			scrollToRect.size.height += spaceBetweenCellAndKeyboard
		} else {
			SwiftyFormLog("cell is fully visible, no need to scroll")
		}
		let inset: CGFloat = tableView.frame.maxY - keyboardFrame.origin.y
		//SwiftyFormLog("inset \(inset)")

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

	/// The keyboard will disappear, restore content insets.
	@objc func keyboardWillHide(_ notification: Notification) {
//		SwiftyFormLog("\n\n\n\nhide")
		innerKeyboardVisible = false

		var contentInset: UIEdgeInsets = tableView.contentInset
		var scrollIndicatorInsets: UIEdgeInsets = tableView.scrollIndicatorInsets

		contentInset.bottom = 0
		scrollIndicatorInsets.bottom = 0

//		SwiftyFormLog("contentInset \(NSStringFromUIEdgeInsets(contentInset))")
//		SwiftyFormLog("scrollIndicatorInsets \(NSStringFromUIEdgeInsets(scrollIndicatorInsets))")

		// Restore insets
		tableView.contentInset = contentInset
		tableView.scrollIndicatorInsets = scrollIndicatorInsets
	}

}
