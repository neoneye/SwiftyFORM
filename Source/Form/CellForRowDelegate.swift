// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public protocol CellForRowDelegate {
	func form_cellForRow(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
}
