// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

/**
# Inline precision slider

### Tap to expand/collapse

### Pinch to zoom for better precision

### Double-tap for zoom

### two-finger double-tap for unzoom

Behind the scenes this creates a `PrecisionSlider`. This is not a standard Apple control.
Please contact Simon Strandgaard if you have questions regarding it.
*/
open class PrecisionSliderFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}
	
	open var title: String = ""
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	/**
	### Collapsed
	
	When the `behavior` is set to `Collapsed` then
	the precision slider starts out being hidden.
	
	The user has to tap the row to expand it.
	This will collapse other inline precision sliders that has `collapseWhenResigning=true`.
	This will not affect other inline precison sliders where `collapseWhenResigning=false`.

	
	### Expanded
	
	When the `behavior` is set to `Expanded` then
	the precision slider starts out being visible.
	
	The user has to tap the row to collapse it.
	
	Also if `collapseWhenResigning=true` and
	another control becomes first respond then this will collapse it.
	When the keyboard appears this will collapse it.
	
	
	### ExpandedAlways
	
	When the `behavior` is set to `ExpandedAlways` then
	the precision slider is always expanded. It cannot be collapsed.
	It is not affected by `becomeFirstResponder()` nor `resignFirstResponder()`.
	*/
	public enum Behavior {
		case collapsed
		case expanded
		case expandedAlways
	}
	open var behavior = Behavior.collapsed
	open func behavior(_ behavior: Behavior) -> Self {
		self.behavior = behavior
		return self
	}
	
	open var collapseWhenResigning = false
	open func shouldCollapseWhenResigning() -> Self {
		self.collapseWhenResigning = true
		return self
	}
	
	/**
	# Initial zoom factor
	
	Automatically determines the best zoom when `initialZoom` is nil
	When zoom is 0 that means no-zoom
	When zoom is +1 that means zoom-in  x10
	When zoom is -1 that means zoom-out x10
	When zoom is +2 that means zoom-in  x100
	When zoom is -2 that means zoom-out x100
	The zoom range is from -5 to +5.
	*/
	open var initialZoom: Float? {
		willSet {
			if let zoom = newValue {
				assert(zoom >= -10, "initialZoom is far outside the zoom-range")
				assert(zoom <= 10, "initialZoom is far outside the zoom-range")
			}
		}
	}
	open func initialZoom(_ initialZoom: Float) -> Self {
		self.initialZoom = initialZoom
		return self
	}

	/**
	# Number of decimal places
	
	The number can go from 0 to +5.
	*/
	open var decimalPlaces: UInt = 3  {
		willSet {
			assert(newValue <= 10, "PrecisionSlider cannot handle so many decimalPlaces. Too big a number.")
		}
	}
	open func decimalPlaces(_ decimalPlaces: UInt) -> Self {
		self.decimalPlaces = decimalPlaces
		return self
	}
	
	open var minimumValue: Int = 0
	open func minimumValue(_ minimumValue: Int) -> Self {
		self.minimumValue = minimumValue
		return self
	}
	
	open var maximumValue: Int = 1000
	open func maximumValue(_ maximumValue: Int) -> Self {
		self.maximumValue = maximumValue
		return self
	}
	
	open var zoomUI = false
	open func enableZoomUI() -> Self {
		self.zoomUI = true
		return self
	}
	
	typealias SyncBlock = (_ value: Int) -> Void
	var syncCellWithValue: SyncBlock = { (value: Int) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: Int = 0
	open var value: Int {
		get {
			return self.innerValue
		}
		set {
			self.updateValue(newValue)
		}
	}
	open func value(_ value: Int) -> Self {
		updateValue(value)
		return self
	}
	
	open func updateValue(_ value: Int) {
		innerValue = value
		syncCellWithValue(value)
	}
	
	open var actualValue: Double {
		let decimalScale: Double = pow(Double(10), Double(decimalPlaces))
		return Double(innerValue) / decimalScale
	}
	
	public struct SliderDidChangeModel {
		public let value: Int
		public let valueUpdated: Bool
		public let zoom: Float
		public let zoomUpdated: Bool
	}

	public typealias SliderDidChangeBlock = (_ changeModel: SliderDidChangeModel) -> Void
	open var sliderDidChangeBlock: SliderDidChangeBlock = { (changeModel: SliderDidChangeModel) in
		SwiftyFormLog("not overridden")
	}
	
	open func sliderDidChange(_ changeModel: SliderDidChangeModel) {
		innerValue = changeModel.value
		sliderDidChangeBlock(changeModel)
	}
}
