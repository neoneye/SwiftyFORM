// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

public class SliderFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var minimumValue: Float = 0.0

	@discardableResult
	public func minimumValue(_ minimumValue: Float) -> Self {
		self.minimumValue = minimumValue
		return self
	}

	public var maximumValue: Float = 1.0

	@discardableResult
	public func maximumValue(_ maximumValue: Float) -> Self {
		self.maximumValue = maximumValue
		return self
	}

	typealias SyncBlock = (_ value: Float, _ animated: Bool) -> Void
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

	@discardableResult
	public func value(_ value: Float) -> Self {
		setValue(value, animated: false)
		return self
	}

	public func setValue(_ value: Float, animated: Bool) {
		innerValue = value
		syncCellWithValue(value, animated)
	}

	public typealias SliderDidChangeBlock = (_ value: Float) -> Void
	public var sliderDidChangeBlock: SliderDidChangeBlock = { (value: Float) in
		SwiftyFormLog("not overridden")
	}

	public func sliderDidChange(_ value: Float) {
		innerValue = value
		sliderDidChangeBlock(value)
	}
}
