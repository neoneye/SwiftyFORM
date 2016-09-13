// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public protocol WillDisplayCellDelegate {
	func form_willDisplay(_ tableView: UITableView, forRowAtIndexPath indexPath: IndexPath)
}
