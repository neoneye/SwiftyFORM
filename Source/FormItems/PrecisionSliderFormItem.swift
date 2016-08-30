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
public class PrecisionSliderFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
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
		case Collapsed
		case Expanded
		case ExpandedAlways
	}
	public var behavior = Behavior.Collapsed
	public func behavior(behavior: Behavior) -> Self {
		self.behavior = behavior
		return self
	}
	
	public var collapseWhenResigning = false
	public func shouldCollapseWhenResigning() -> Self {
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
	public var initialZoom: Float? {
		willSet {
			if let zoom = newValue {
				assert(zoom >= -10, "initialZoom is far outside the zoom-range")
				assert(zoom <= 10, "initialZoom is far outside the zoom-range")
			}
		}
	}
	public func initialZoom(initialZoom: Float) -> Self {
		self.initialZoom = initialZoom
		return self
	}

	/**
	# Number of decimal places
	
	The number can go from 0 to +5.
	*/
	public var decimalPlaces: UInt = 3  {
		willSet {
			assert(newValue <= 10, "PrecisionSlider cannot handle so many decimalPlaces. Too big a number.")
		}
	}
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
	
	public var zoomUI = false
	public func enableZoomUI() -> Self {
		self.zoomUI = true
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
		public let value: Int
		public let valueUpdated: Bool
		public let zoom: Float
		public let zoomUpdated: Bool
	}

	public typealias SliderDidChangeBlock = (changeModel: SliderDidChangeModel) -> Void
	public var sliderDidChangeBlock: SliderDidChangeBlock = { (changeModel: SliderDidChangeModel) in
		SwiftyFormLog("not overridden")
	}
	
	public func sliderDidChange(changeModel: SliderDidChangeModel) {
		innerValue = changeModel.value
		sliderDidChangeBlock(changeModel: changeModel)
	}
}
