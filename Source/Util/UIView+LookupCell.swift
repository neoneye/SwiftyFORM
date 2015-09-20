// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

extension UIView {
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
