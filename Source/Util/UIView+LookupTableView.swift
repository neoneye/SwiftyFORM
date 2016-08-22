// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

extension UIView {
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