// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

extension UIView {
	func form_firstResponder() -> UIView? {
		if self.isFirstResponder() {
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
