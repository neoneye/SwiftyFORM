// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public protocol CellHeightProvider {
	func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat
}
