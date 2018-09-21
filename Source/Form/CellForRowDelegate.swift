// MIT license. Copyright (c) 2018 SwiftyFORM. All rights reserved.
import UIKit

public protocol CellForRowDelegate {
	func form_cellForRow(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
}
