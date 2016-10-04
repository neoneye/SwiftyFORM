## 📄 Change Log

### 1.1.0

 * Imported specification pattern unittests
 * Enabled Travis CI.

### 1.0.1

 * Fixed podfile

### 1.0.0

 * Major breaking changes, thus I'm incrementing version number from 0.x.x to 1.x.x
 * Breaking: Upgraded from Swift 2.3 to Swift 3
 * Breaking: Upgraded from Xcode 7.3.1 to Xcode 8.0
 * Breaking: `CellHeightProvider.form_cellHeight()` now requires the name of the first parameter
 * Breaking: `CellForRowDelegate.form_cellForRow()` now requires the name of the first parameter
 * Breaking: `SelectOptionDelegate.form_willSelectOption()` now requires the name of the first parameter
 * Breaking: `SelectRowDelegate.form_didSelectRow()` now requires the name of the first parameter
 * Breaking: `WillDisplayCellDelegate.form_willDisplay()` now requires the name of the first parameter
 * Breaking: Leaf classes can no longer be subclassed, such as `AttributedTextFormItem`, `ButtonFormItem`, `CustomFormItem`, `DatePickerFormItem`, etc. These were subclassable. The `FormItem` can still be subclassed, since it's the base class for all form items.
 * Breaking: Enabled "Self Sizing Cells" in `FormTableView`
 * Added `FormBuilder.suppressHeaderForFirstSection` that hides the first header in the tableview

### 0.11.0

 * Added `PickerViewFormItem` that makes it possible to use inline `UIPickerView`.
 * Added `PickerViewViewController` that shows how to use the `PickerViewFormItem`.
 * Sorted visitor functions alphabetically.
 * Added more examples to the `readme`

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
