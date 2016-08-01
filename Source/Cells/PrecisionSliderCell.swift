// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class PrecisionSliderCellModel {
	var title: String?
	var decimalPlaces: UInt = 3
	var value: Int = 0
	var minimumValue: Int = 0
	var maximumValue: Int = 1000
	

	public struct SliderDidChangeModel {
		let value: Int
		let valueUpdated: Bool
		let zoom: Float
		let zoomUpdated: Bool
	}
	
	public typealias SliderDidChangeBlock = (changeModel: SliderDidChangeModel) -> Void
	var valueDidChange: SliderDidChangeBlock = { (changeModel: SliderDidChangeModel) in
		SwiftyFormLog("value \(changeModel.value)  zoom \(changeModel.zoom)")
	}
	
	var actualValue: Double {
		let decimalScale: Double = pow(Double(10), Double(decimalPlaces))
		return Double(value) / decimalScale
	}
}

public struct PrecisionSliderCellFormatter {
	public static func format(value value: Int, decimalPlaces: UInt) -> String {
		let decimalScale: Int = Int(pow(Double(10), Double(decimalPlaces)))
		let integerValue = abs(value / decimalScale)
		let sign: String = value < 0 ? "-" : ""
		
		let fractionString: String
		if decimalPlaces > 0 {
			let fractionValue = abs(value % decimalScale)
			let fmt = ".%0\(decimalPlaces)i"
			fractionString = String(format: fmt, fractionValue)
		} else {
			fractionString = ""
		}
		
		return "\(sign)\(integerValue)\(fractionString)"
	}
}


public class PrecisionSliderCell: UITableViewCell, CellHeightProvider, SelectRowDelegate {
	weak var expandedCell: PrecisionSliderCellExpanded?
	public let model: PrecisionSliderCellModel

	public init(model: PrecisionSliderCellModel) {
		self.model = model
		super.init(style: .Value1, reuseIdentifier: nil)
		selectionStyle = .None
		clipsToBounds = true
		textLabel?.text = model.title
		reloadValueLabel()
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		return 60
	}
	
	public func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView) {
		guard let tableView = tableView as? FormTableView else {
			return
		}
		guard let expandedCell = expandedCell else {
			return
		}
		tableView.expandCollapse(expandedCell: expandedCell, indexPath: indexPath)
	}
	
	func reloadValueLabel() {
		detailTextLabel?.text = PrecisionSliderCellFormatter.format(value: model.value, decimalPlaces: model.decimalPlaces)
	}
	
	func sliderDidChange(newValueOrNil: Double?) {
		var newValueOrZero: Int = 0
		
		if let newValue = newValueOrNil {
			let decimalScale: Double = pow(Double(10), Double(model.decimalPlaces))
			newValueOrZero = Int(round(newValue * decimalScale))
		}
		
		if model.value == newValueOrZero {
			return
		}
		model.value = newValueOrZero
		
		let changeModel = PrecisionSliderCellModel.SliderDidChangeModel(
			value: newValueOrZero,
			valueUpdated: true,
			zoom: 0,  // TODO: pass zoom all the way from the slider
			zoomUpdated: false
		)
		
		model.valueDidChange(changeModel: changeModel)
		reloadValueLabel()
	}
}

extension PrecisionSliderCellModel {
	struct Constants {
		static let markerSpacing: Double = 30.0
		static let initialInset: CGFloat = 30.0
		static let maxZoomedOut_Inset: CGFloat = 100.0
		static let maxZoomedIn_DistanceBetweenMarks: Double = 60
	}
	
	func sliderViewModel(sliderWidth sliderWidth: CGFloat) -> PrecisionSlider_InnerModel {
		let decimalScale: Double = pow(Double(10), Double(decimalPlaces))
		let minimumValue = Double(self.minimumValue) / decimalScale
		let maximumValue = Double(self.maximumValue) / decimalScale
		
		let instance = PrecisionSlider_InnerModel()
		instance.originalMinimumValue = minimumValue
		instance.originalMaximumValue = maximumValue
		
		let rangeLength = maximumValue - minimumValue
		
		let markerSpacing = Constants.markerSpacing
		instance.markerSpacing = markerSpacing
		
		let initialSliderWidth = Double(sliderWidth - Constants.initialInset)
		if initialSliderWidth > 10 && rangeLength > 0.001 {
			instance.scale = log10((initialSliderWidth / rangeLength) / markerSpacing)
		} else {
			instance.scale = 0
		}

		let maxZoomOutSliderWidth = Double(sliderWidth - Constants.maxZoomedOut_Inset)
		if maxZoomOutSliderWidth > 10 && rangeLength > 0.001 {
			instance.minimumScale = log10((maxZoomOutSliderWidth / rangeLength) / markerSpacing)
		} else {
			instance.minimumScale = 0
		}

		instance.maximumScale = log10(Constants.maxZoomedIn_DistanceBetweenMarks * decimalScale / markerSpacing)
		
		// Prevent negative scale-range
		if instance.minimumScale > instance.maximumScale {
			//print("preventing negative scale-range: from \(instance.minimumScale) to \(instance.maximumScale)")
			instance.maximumScale = instance.minimumScale
			instance.scale = instance.minimumScale
		}
		//SwiftyFormLog("slider model: \(instance)")
		return instance
	}
}

public class PrecisionSliderCellExpanded: UITableViewCell, CellHeightProvider {
	weak var collapsedCell: PrecisionSliderCell?

	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		return PrecisionSlider_InnerModel.height
	}
	
	func sliderDidChange() {
		collapsedCell?.sliderDidChange(slider.value)
	}
	
	lazy var slider: PrecisionSlider = {
		let instance = PrecisionSlider()
		instance.valueDidChange = nil
		return instance
	}()
	
	public init() {
		super.init(style: .Default, reuseIdentifier: nil)
		addSubview(slider)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		slider.frame = bounds
		
		let tinyDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Float(NSEC_PER_SEC)))
		dispatch_after(tinyDelay, dispatch_get_main_queue()) {
			self.assignInitialValue()
		}
	}
	
	func assignInitialValue() {
		if slider.valueDidChange != nil {
			return
		}
		guard let model = collapsedCell?.model else {
			return
		}
		
		let sliderViewModel = model.sliderViewModel(sliderWidth: slider.bounds.width)
		slider.model = sliderViewModel
		slider.layout.model = sliderViewModel
		slider.reloadSlider()

		let decimalScale: Double = pow(Double(10), Double(model.decimalPlaces))
		let scaledValue = Double(model.value) / decimalScale

		/*
		First we scroll to the right offset
		Next establish two way binding
		*/
		slider.value = scaledValue

		slider.valueDidChange = { [weak self] in
			self?.sliderDidChange()
		}
	}
	
	func setValueWithoutSync(value: Int) {
		guard let model = collapsedCell?.model else {
			return
		}
		SwiftyFormLog("set value \(value)")
		
		let decimalScale: Double = pow(Double(10), Double(model.decimalPlaces))
		let scaledValue = Double(value) / decimalScale
		slider.value = scaledValue
	}
}
