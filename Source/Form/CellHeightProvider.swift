// MIT license. Copyright (c) 2019 SwiftyFORM. All rights reserved.
import UIKit

public protocol CellHeightProvider {
	func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat
}
