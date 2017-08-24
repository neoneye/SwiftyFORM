// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

public struct SwitchCellModel {
	var title: String = ""

	var valueDidChange: (Bool) -> Void = { (value: Bool) in
		SwiftyFormLog("value \(value)")
	}
}

public class SwitchCell: UITableViewCell {
	public let model: SwitchCellModel
	public let switchView: UISwitch

	public init(model: SwitchCellModel) {
		self.model = model
		self.switchView = UISwitch()
		super.init(style: .default, reuseIdentifier: nil)
		selectionStyle = .none
		textLabel?.text = model.title

		switchView.addTarget(self, action: #selector(SwitchCell.valueChanged), for: .valueChanged)
		accessoryView = switchView
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc public func valueChanged() {
		SwiftyFormLog("value did change")
		model.valueDidChange(switchView.isOn)
	}

	public func setValueWithoutSync(_ value: Bool, animated: Bool) {
		SwiftyFormLog("set value \(value), animated \(animated)")
		switchView.setOn(value, animated: animated)
	}

}
