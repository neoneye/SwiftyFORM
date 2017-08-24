// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

extension UIView {
	/// Find the first responder.
	///
	/// This function is recursive.
	///
	/// - returns: the first responder otherwise nil.
	public func form_firstResponder() -> UIView? {
		if self.isFirstResponder {
			return self
		}
		for subview in subviews {
			let responder = subview.form_firstResponder()
			if responder != nil {
				return responder
			}
		}
		return nil
	}
}
