## 📄 Change Log

### 0.11.0

 * Added `PickerViewFormItem` that makes it possible to use inline `UIPickerView`.
 * Added `PickerViewViewController` that shows how to use the `PickerViewFormItem`.
 * Sorted visitor functions alphabetically.

### 0.10.0

 * Date pickers are now inline. Previous the date pickers was iOS6 style and shown at the bottom of the screen. It felt old. (#8)
 * The `PrecisionSlider` now implements `UIResponder`. If you set `collapseWhenResigning=true` then the slider will collapse when another control becomes first responder. 
 * Bumped up the minimum version of iOS to `9.0`.
 * Added `DatePickerBindingViewController` example.
 * Added `SlidersAndTextFieldsViewController` example.

### 0.9.2

 * The `PrecisionSlider` can now sync its zoom level. This could make it possible to store the zoom level in `NSUserDefaults`.
 * After expand/collapse the cell could end up out side the visible area. Now it's scrolled into the visible area.
 
### 0.9.1

 * The `PrecisionSlider` can now be zoomed in/out, by pinching with 2 fingers.
 * The `PrecisionSlider` can now be x10 zoomed in by double tapping with 1 finger.
 * The `PrecisionSlider` can now be x10 zoomed out by double tapping with 2 fingers.
 * Support for Carthage.

### 0.9.0

 * Added `PrecisionSliderFormItem` and `PrecisionSliderCell`.
 
### 0.8.1

 * Added `AttributedTextFormItem` and `AttributedTextCell`.
 
### 0.8.0

 * Added `SegmentedControlFormItem` and `SegmentedControlCell`, 
 * Added `SegmentedControlsViewController` example.
 
### 0.7.1 and 0.7.0

 * Support for CocoaPods.

### 0.6.0

 * `FormTableView` now with `estimatedRowHeight`
 * `TableViewSection` now with `UITableViewAutomaticDimension`
 * Upgrade to Xcode7.3.1 (7D1014)
 
### 0.5.1

 * `StaticTextFormItem` can now sync its `value` with the cell.
 * Upgrade to Xcode7.3 (7D175)
