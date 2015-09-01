//
//  CellHeightProvider.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 25/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit

@objc public protocol CellHeightProvider {
	func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat
}
