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

	public typealias SliderDidChangeBlock = (value: Int) -> Void
	public var sliderDidChangeBlock: SliderDidChangeBlock = { (value: Int) in
		SwiftyFormLog("not overridden")
	}
	
	public func sliderDidChange(value: Int) {
		innerValue = value
		sliderDidChangeBlock(value: value)
	}
}
