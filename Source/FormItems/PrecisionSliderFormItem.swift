// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
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
	
	
	typealias SyncBlock = (value: Int, animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: Int, animated: Bool) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: Int = 0
	public var value: Int {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	public func value(value: Int) -> Self {
		setValue(value, animated: false)
		return self
	}
	
	public func setValue(value: Int, animated: Bool) {
		innerValue = value
		syncCellWithValue(value: value, animated: animated)
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
