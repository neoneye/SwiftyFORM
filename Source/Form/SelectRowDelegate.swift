// MIT license. Copyright (c) 2020 SwiftyFORM. All rights reserved.
import UIKit

public protocol SelectRowDelegate {
	func form_didSelectRow(indexPath: IndexPath, tableView: UITableView)
}
