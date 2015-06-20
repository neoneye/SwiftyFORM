//
//  OptionCell.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 08/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit

public class OptionCell: UITableViewCell, SelectRowDelegate {
	let innerDidSelectOption: Void -> Void
	
	public init(model: OptionRowFormItem, didSelectOption: Void -> Void) {
		self.innerDidSelectOption = didSelectOption
		super.init(style: .Default, reuseIdentifier: nil)
		loadWithModel(model)
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func loadWithModel(model: OptionRowFormItem) {
		textLabel?.text = model.title
		if model.selected {
			accessoryType = .Checkmark
		} else {
			accessoryType = .None
		}
	}

	public func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView) {
		DLog("will invoke")
		accessoryType = .Checkmark
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)

		innerDidSelectOption()
		DLog("did invoke")
	}
}
