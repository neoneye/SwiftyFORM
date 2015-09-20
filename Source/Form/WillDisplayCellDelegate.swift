// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import UIKit

@objc public protocol WillDisplayCellDelegate {
	func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: NSIndexPath)
}
