// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

extension UIView {
	/// Find the first UITableViewCell among all the superviews.
	///
	/// - returns: the found cell otherwise nil.
	func form_cell() -> UITableViewCell? {
		var viewOrNil: UIView? = self
		while let view = viewOrNil {
			if let cell = view as? UITableViewCell {
				return cell
			}
			viewOrNil = view.superview
		}
		return nil
	}
}
