## 📄 Change Log

### 1.6.0

 * Upgraded from Xcode9.0 to Xcode9.2
 * Upgraded from Swift3 to Swift4

### 1.5.0

 * Xcode9 preparations. Now compiles with Xcode9beta6.
 * Swiftlint

### 1.4.0

 * Upgraded from Xcode8.2.1 to Xcode8.3.1
 * Classes derived from FormViewController can now be used inside storyboards. Added 'SettingsViewController' that demonstrates this.
   FormViewController.init(coder aDecoder: NSCoder) have until now invoked super.init(nibName: nil, bundle: nil) so it has never worked inside a storyboard.
   FormViewController now instead implements init?(coder aDecoder: NSCoder) so it can invoke super.init(coder: aDecoder).
 * FormViewController.reloadForm() added.

### 1.3.0

 * iPad: cells now adheres to `cellLayoutMarginsFollowReadableWidth = true` and uses the layoutMargin left/right for computing the frames.
 * DatePickerFormItem.minuteInterval added.

### 1.2.0

 * Simplified specification pattern. In the future the `CompositeSpecification` class will be removed. Instead of subclassing `CompositeSpecification` one must instead subclass `Specification`.
 * Simplified the `CharacterSetSpecification` factory functions. In the future the `CharacterSetSpecification` the oldschool factory functions will be removed.
 * Fixed crash in the `Sign Up` example code. Tapping the "Export to JSON" button always crashed. The problem was introduced in the `DumpVisitor` class when the project got migrated from Xcode7 to Xcode8.
 * Wrote documentation for the files in `Source/Util` and `Source/Specification`. 
 * Upgraded from Xcode 8.0 to Xcode 8.1
 * Fixed crash: When using a custom view for the section header and providing a height less than 10 pixels could cause expand/collapse to crash.  
 * Longer section header titles affects expand/collapse animations. Here it's better to use a custom view as section header.

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
