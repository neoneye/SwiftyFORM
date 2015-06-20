//
//  StaticTextCell.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 08/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit

public struct StaticTextCellModel {
	var title: String = ""
	var value: String = ""
}

public class StaticTextCell: UITableViewCell {
	public let model: StaticTextCellModel

	public init(model: StaticTextCellModel) {
		self.model = model
		super.init(style: .Value1, reuseIdentifier: nil)
		loadWithModel(model)
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func loadWithModel(model: StaticTextCellModel) {
		selectionStyle = .None
		textLabel?.text = model.title
		detailTextLabel?.text = model.value
	}

}
