// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public protocol CellHeightProvider {
	func form_cellHeight(_ indexPath: IndexPath, tableView: UITableView) -> CGFloat
}
