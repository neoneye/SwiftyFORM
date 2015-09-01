//
//  LoadingCell.swift
//  Example
//
//  Created by Simon Strandgaard on 01-09-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import UIKit
import SwiftyFORM

class LoadingCell: UITableViewCell, CellHeightProvider {
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	var xibHeight: CGFloat = 160

	static func createCell() throws -> LoadingCell {
		let cell: LoadingCell = try NSBundle.mainBundle().form_loadView("LoadingCell")
		return cell
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		xibHeight = bounds.height
		activityIndicator.startAnimating()
    }

	func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		return xibHeight
	}
}
