// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

@objc public protocol SelectRowDelegate {
	func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView)
}
