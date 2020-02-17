// MIT license. Copyright (c) 2020 SwiftyFORM. All rights reserved.
import UIKit

public protocol WillDisplayCellDelegate {
	func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath)
}
