//
//  SelectRowDelegate.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 09/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit

@objc public protocol SelectRowDelegate {
	func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView)
}
