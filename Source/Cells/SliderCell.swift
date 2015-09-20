// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import UIKit

public struct SliderCellModel {
	var title: String = ""
	var value: Float = 0.0
	var minimumValue: Float = 0.0
	var maximumValue: Float = 1.0

	var valueDidChange: Float -> Void = { (value: Float) in
		DLog("value \(value)")
	}
}

public class SliderCell: UITableViewCell, CellHeightProvider {
	public let model: SliderCellModel
	
	public let slider = UISlider()

	public init(model: SliderCellModel) {
		self.model = model
		super.init(style: .Default, reuseIdentifier: nil)
		selectionStyle = .None
		
		contentView.addSubview(slider)
		
		slider.minimumValue = model.minimumValue
		slider.maximumValue = model.maximumValue
		slider.value = model.value
		slider.addTarget(self, action: "valueChanged", forControlEvents: .ValueChanged)
		
		clipsToBounds = true
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		
		slider.sizeToFit()
		slider.frame = bounds.insetBy(dx: 16, dy: 0)
	}

	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		return 60
	}
	
	public func valueChanged() {
		DLog("value did change")
		model.valueDidChange(slider.value)
	}
	
	public func setValueWithoutSync(value: Float, animated: Bool) {
		DLog("set value \(value), animated \(animated)")
		slider.setValue(value, animated: animated)
	}
}
