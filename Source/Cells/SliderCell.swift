// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
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

open class SliderCell: UITableViewCell, CellHeightProvider {
	open let model: SliderCellModel
	
	open let slider = UISlider()

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

	open override func layoutSubviews() {
		super.layoutSubviews()
		
		slider.sizeToFit()
		slider.frame = bounds.insetBy(dx: 16, dy: 0)
	}

	open func form_cellHeight(_ indexPath: IndexPath, tableView: UITableView) -> CGFloat {
		return 60
	}
	
	open func valueChanged() {
		SwiftyFormLog("value did change")
		model.valueDidChange(slider.value)
	}
	
	open func setValueWithoutSync(_ value: Float, animated: Bool) {
		SwiftyFormLog("set value \(value), animated \(animated)")
		slider.setValue(value, animated: animated)
	}
}
