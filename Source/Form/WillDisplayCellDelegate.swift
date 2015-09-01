//  Copyright © 2015 Simon Strandgaard. All rights reserved.
import UIKit

@objc protocol WillDisplayCellDelegate {
	func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: NSIndexPath)
}
