// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public struct StepperCellModel {
	var title: String = ""
	var value: Int = 0

	var valueDidChange: Int -> Void = { (value: Int) in
		DLog("value \(value)")
	}
}

public class StepperCell: UITableViewCell {
	public let model: StepperCellModel
	public let valueLabel = UILabel()
	public let stepperView = UIStepper()
	public var containerView = UIView()
	
	public init(model: StepperCellModel) {
		self.model = model
		super.init(style: .Value1, reuseIdentifier: nil)
		selectionStyle = .None
		textLabel?.text = model.title

		valueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		valueLabel.textColor = UIColor.grayColor()
		containerView.addSubview(stepperView)
		containerView.addSubview(valueLabel)
		accessoryView = containerView

		stepperView.addTarget(self, action: "valueChanged", forControlEvents: .ValueChanged)

		valueLabel.text = "0"
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		stepperView.sizeToFit()
		valueLabel.sizeToFit()
		
		let rightPadding: CGFloat = 17
		let valueStepperPadding: CGFloat = 10
		
		let valueSize = valueLabel.frame.size
		let stepperSize = stepperView.frame.size
		
		let containerWidth = ceil(valueSize.width + valueStepperPadding + stepperSize.width)
		containerView.frame = CGRectMake(bounds.width - rightPadding - containerWidth, 0, containerWidth, stepperSize.height)
		
		let valueY: CGFloat = bounds.midY - valueSize.height / 2
		valueLabel.frame = CGRectIntegral(CGRectMake(0, valueY, valueSize.width, valueSize.height))
		
		let stepperY: CGFloat = bounds.midY - stepperSize.height / 2
		stepperView.frame = CGRectMake(containerWidth - stepperSize.width, stepperY, stepperSize.width, stepperSize.height)
	}
	
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func valueChanged() {
		DLog("value did change")

		let value: Double = stepperView.value
		let intValue: Int = Int(round(value))

		updateValue(intValue)

		model.valueDidChange(intValue)
		setNeedsLayout()
	}

	public func updateValue(value: Int) {
		let value: Double = stepperView.value
		let intValue: Int = Int(round(value))

		self.valueLabel.text = "\(intValue)"
	}

	public func setValueWithoutSync(value: Int, animated: Bool) {
		DLog("set value \(value)")

		stepperView.value = Double(value)
		updateValue(value)
	}
}

