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
	
	public var minimumValue: Double = 0.0
	public func minimumValue(minimumValue: Double) -> Self {
		self.minimumValue = minimumValue
		return self
	}
	
	public var maximumValue: Double = 1.0
	public func maximumValue(maximumValue: Double) -> Self {
		self.maximumValue = maximumValue
		return self
	}
	
	
	typealias SyncBlock = (value: Double, animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: Double, animated: Bool) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: Double = 0.0
	public var value: Double {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	public func value(value: Double) -> Self {
		setValue(value, animated: false)
		return self
	}
	
	public func setValue(value: Double, animated: Bool) {
		innerValue = value
		syncCellWithValue(value: value, animated: animated)
	}

	public typealias SliderDidChangeBlock = (value: Double) -> Void
	public var sliderDidChangeBlock: SliderDidChangeBlock = { (value: Double) in
		SwiftyFormLog("not overridden")
	}
	
	public func sliderDidChange(value: Double) {
		innerValue = value
		sliderDidChangeBlock(value: value)
	}
}
