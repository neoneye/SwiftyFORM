// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public class PrecisionSliderFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitPrecisionSlider(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	public var decimalPlaces: UInt = 3
	public func decimalPlaces(decimalPlaces: UInt) -> Self {
		self.decimalPlaces = decimalPlaces
		return self
	}
	
	public var minimumValue: Int = 0
	public func minimumValue(minimumValue: Int) -> Self {
		self.minimumValue = minimumValue
		return self
	}
	
	public var maximumValue: Int = 1000
	public func maximumValue(maximumValue: Int) -> Self {
		self.maximumValue = maximumValue
		return self
	}
	
	
	typealias SyncBlock = (value: Int) -> Void
	var syncCellWithValue: SyncBlock = { (value: Int) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: Int = 0
	public var value: Int {
		get {
			return self.innerValue
		}
		set {
			self.updateValue(newValue)
		}
	}
	public func value(value: Int) -> Self {
		updateValue(value)
		return self
	}
	
	public func updateValue(value: Int) {
		innerValue = value
		syncCellWithValue(value: value)
	}
	
	public var actualValue: Double {
		let decimalScale: Double = pow(Double(10), Double(decimalPlaces))
		return Double(innerValue) / decimalScale
	}
	
	public struct SliderDidChangeModel {
		let value: Int
		let valueUpdated: Bool
		let zoom: Float
		let zoomUpdated: Bool
	}

	public typealias SliderDidChangeBlock = (changeModel: SliderDidChangeModel) -> Void
	public var sliderDidChangeBlock: SliderDidChangeBlock = { (changeModel: SliderDidChangeModel) in
		SwiftyFormLog("not overridden")
	}
	
	public func sliderDidChange(changeModel: SliderDidChangeModel) {
		if changeModel.valueUpdated {
			print("value: \(changeModel.value)")
		}
		if changeModel.zoomUpdated {
			print("zoom: \(changeModel.zoom)")
		}
		innerValue = changeModel.value
		//TODO: innerZoom = changeModel.zoom
		sliderDidChangeBlock(changeModel: changeModel)
	}
}
