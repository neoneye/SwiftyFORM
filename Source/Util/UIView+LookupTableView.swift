// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

extension UIView {
	/// Find the first UITableView among all the superviews.
	///
	/// - returns: the found tableview otherwise nil.
	func form_tableView() -> UITableView? {
		var viewOrNil: UIView? = self
		while let view = viewOrNil {
			if let tableView = view as? UITableView {
				return tableView
			}
			viewOrNil = view.superview
		}
		return nil
	}
}
