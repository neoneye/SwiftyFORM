// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public class SliderFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	public var minimumValue: Float = 0.0
	public func minimumValue(minimumValue: Float) -> Self {
		self.minimumValue = minimumValue
		return self
	}
	
	public var maximumValue: Float = 1.0
	public func maximumValue(maximumValue: Float) -> Self {
		self.maximumValue = maximumValue
		return self
	}
	
	
	typealias SyncBlock = (value: Float, animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: Float, animated: Bool) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: Float = 0.0
	public var value: Float {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	public func value(value: Float) -> Self {
		setValue(value, animated: false)
		return self
	}
	
	public func setValue(value: Float, animated: Bool) {
		innerValue = value
		syncCellWithValue(value: value, animated: animated)
	}

	public typealias SliderDidChangeBlock = (value: Float) -> Void
	public var sliderDidChangeBlock: SliderDidChangeBlock = { (value: Float) in
		SwiftyFormLog("not overridden")
	}
	
	public func sliderDidChange(value: Float) {
		innerValue = value
		sliderDidChangeBlock(value: value)
	}
}
