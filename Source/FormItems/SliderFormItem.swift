// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class SliderFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var minimumValue: Float = 0.0
	open func minimumValue(_ minimumValue: Float) -> Self {
		self.minimumValue = minimumValue
		return self
	}
	
	open var maximumValue: Float = 1.0
	open func maximumValue(_ maximumValue: Float) -> Self {
		self.maximumValue = maximumValue
		return self
	}
	
	
	typealias SyncBlock = (_ value: Float, _ animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: Float, animated: Bool) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: Float = 0.0
	open var value: Float {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	open func value(_ value: Float) -> Self {
		setValue(value, animated: false)
		return self
	}
	
	open func setValue(_ value: Float, animated: Bool) {
		innerValue = value
		syncCellWithValue(value, animated)
	}

	public typealias SliderDidChangeBlock = (_ value: Float) -> Void
	open var sliderDidChangeBlock: SliderDidChangeBlock = { (value: Float) in
		SwiftyFormLog("not overridden")
	}
	
	open func sliderDidChange(_ value: Float) {
		innerValue = value
		sliderDidChangeBlock(value)
	}
}
