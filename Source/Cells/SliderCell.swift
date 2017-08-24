// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

public struct SliderCellModel {
	var title: String = ""
	var value: Float = 0.0
	var minimumValue: Float = 0.0
	var maximumValue: Float = 1.0

	var valueDidChange: (Float) -> Void = { (value: Float) in
		SwiftyFormLog("value \(value)")
	}
}

public class SliderCell: UITableViewCell, CellHeightProvider {
	public let model: SliderCellModel

	public let slider = UISlider()

	public init(model: SliderCellModel) {
		self.model = model
		super.init(style: .default, reuseIdentifier: nil)
		selectionStyle = .none

		contentView.addSubview(slider)

		slider.minimumValue = model.minimumValue
		slider.maximumValue = model.maximumValue
		slider.value = model.value
		slider.addTarget(self, action: #selector(SliderCell.valueChanged), for: .valueChanged)

		clipsToBounds = true
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		slider.sizeToFit()

		var inset = self.layoutMargins
		inset.top = 0
		inset.bottom = 0
		slider.frame = UIEdgeInsetsInsetRect(bounds, layoutMargins)
	}

	public func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
		return 60
	}

	@objc public func valueChanged() {
		SwiftyFormLog("value did change")
		model.valueDidChange(slider.value)
	}

	public func setValueWithoutSync(_ value: Float, animated: Bool) {
		SwiftyFormLog("set value \(value), animated \(animated)")
		slider.setValue(value, animated: animated)
	}
}
