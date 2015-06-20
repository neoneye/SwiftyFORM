//
//  SwitchCell.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 24/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit

public struct SwitchCellModel {
	var title: String = ""

	var valueDidChange: Bool -> Void = { (value: Bool) in
		DLog("value \(value)")
	}
}

public class SwitchCell: UITableViewCell {
	public let model: SwitchCellModel
	public let switchView: UISwitch
	
	public init(model: SwitchCellModel) {
		self.model = model
		self.switchView = UISwitch()
		super.init(style: .Default, reuseIdentifier: nil)
		selectionStyle = .None
		textLabel?.text = model.title
		
		switchView.addTarget(self, action: "valueChanged", forControlEvents: .ValueChanged)
		accessoryView = switchView
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func valueChanged() {
		DLog("value did change")
		model.valueDidChange(switchView.on)
	}

	public func setValueWithoutSync(value: Bool, animated: Bool) {
		DLog("set value \(value), animated \(animated)")
		switchView.setOn(value, animated: animated)
	}
	
}

