// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public struct SegmentedControlCellModel {
	var title: String = ""
	
	var items: [String] = ["a", "b", "c"]
	var value = 0
	
	var valueDidChange: Int -> Void = { (value: Int) in
		SwiftyFormLog("value \(value)")
	}
}

public class SegmentedControlCell: UITableViewCell {
	public let model: SegmentedControlCellModel
	public let segmentedControl: UISegmentedControl
	
	public init(model: SegmentedControlCellModel) {
		self.model = model
		self.segmentedControl = UISegmentedControl(items: model.items)
		super.init(style: .Default, reuseIdentifier: nil)
		selectionStyle = .None
		textLabel?.text = model.title
		segmentedControl.selectedSegmentIndex = model.value
		segmentedControl.addTarget(self, action: #selector(SegmentedControlCell.valueChanged), forControlEvents: .ValueChanged)
		accessoryView = segmentedControl
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func valueChanged() {
		SwiftyFormLog("value did change")
		model.valueDidChange(segmentedControl.selectedSegmentIndex)
	}
	
	public func setValueWithoutSync(value: Int) {
		SwiftyFormLog("set value \(value)")
		segmentedControl.selectedSegmentIndex = value
	}
}
