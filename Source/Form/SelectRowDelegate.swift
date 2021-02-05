// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit

public protocol SelectRowDelegate {
	func form_didSelectRow(indexPath: IndexPath, tableView: UITableView)
}
