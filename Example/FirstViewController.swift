// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class FirstViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "SwiftyFORM"
		builder.demo_showInfo("Welcome to the\nSwiftyFORM example app\nthat shows everything")

		builder += SectionHeaderTitleFormItem().title("Tutorial")
		builder += ViewControllerFormItem().title("StaticText").viewController(Tutorial0_StaticText_ViewController.self)
		builder += ViewControllerFormItem().title("TextField").viewController(Tutorial1_TextField_ViewController.self)
		builder += ViewControllerFormItem().title("Child ViewController").viewController(Tutorial2_ChildViewController_ViewController.self)

		builder += SectionHeaderTitleFormItem().title("Usecases")
		builder += ViewControllerFormItem().title("Sign Up").viewController(SignUpViewController.self)
		builder += ViewControllerFormItem().title("Color Picker").viewController(ColorPickerViewController.self)
		builder += ViewControllerFormItem().title("Settings").storyboard("Settings", bundle: nil)
		builder += ViewControllerFormItem().title("Change Password").viewController(ChangePasswordViewController.self)
		builder += ViewControllerFormItem().title("Report").viewController(ReportViewController.self)
		builder += ViewControllerFormItem().title("Rate").viewController(RateAppViewController.self)
		builder += ViewControllerFormItem().title("Storyboard Demo").viewController(StoryboardDemoViewController.self)
		builder += ViewControllerFormItem().title("Area 51").storyboard("Area51", bundle: nil)

		builder += SectionHeaderTitleFormItem().title("Non-SwiftyFORM")
		builder += ViewControllerFormItem().title("UICollectionViewController").viewController(MyCollectionViewController.self)
		builder += ViewControllerFormItem().title("UITableViewController").viewController(MyTableViewController.self)

		builder += SectionHeaderTitleFormItem().title("TextField")
		builder += ViewControllerFormItem().title("Valid & Invalid").viewController(TextFieldValidInvalidViewController.self)
		builder += ViewControllerFormItem().title("Keyboard Types").viewController(TextFieldKeyboardTypesViewController.self)
		builder += ViewControllerFormItem().title("Tab Through Form").viewController(TextFieldTabThroughFormViewController.self)
        builder += ViewControllerFormItem().title("Return Key").viewController(TextFieldReturnKeyViewController.self)
        builder += ViewControllerFormItem().title("Editing End").viewController(TextFieldEditingEndViewController.self)

		builder += SectionHeaderTitleFormItem().title("TextView")
		builder += ViewControllerFormItem().title("TextViews").viewController(TextViewViewController.self)

		builder += SectionHeaderTitleFormItem().title("DatePicker")
		builder += ViewControllerFormItem().title("DatePicker With Locale").viewController(DatePickerLocaleViewController.self)
		builder += ViewControllerFormItem().title("DatePicker With Range").viewController(DatePickerRangeViewController.self)
		builder += ViewControllerFormItem().title("DatePicker With Initial Value").viewController(DatePickerInitialValueViewController.self)
		builder += ViewControllerFormItem().title("DatePicker With Bindings").viewController(DatePickerBindingViewController.self)

		builder += SectionHeaderTitleFormItem().title("Header & Footer")
		builder += ViewControllerFormItem().title("Header & Footer").viewController(HeaderFooterViewController.self)
		builder += ViewControllerFormItem().title("No Header").viewController(NoHeaderViewController.self)

		builder += SectionHeaderTitleFormItem().title("Other")
		builder += ViewControllerFormItem().title("Static & Attributed Text").viewController(StaticTextAndAttributedTextViewController.self)
		builder += ViewControllerFormItem().title("Buttons").viewController(ButtonsViewController.self)
		builder += ViewControllerFormItem().title("Sliders").viewController(SlidersViewController.self)
		builder += ViewControllerFormItem().title("Segmented Controls").viewController(SegmentedControlsViewController.self)
		builder += ViewControllerFormItem().title("Options").viewController(OptionsViewController.self)
		builder += ViewControllerFormItem().title("Steppers").viewController(SteppersViewController.self)
		builder += ViewControllerFormItem().title("Custom Cells").viewController(CustomViewController.self)
		builder += ViewControllerFormItem().title("PickerView").viewController(PickerViewViewController.self)
		builder += ViewControllerFormItem().title("Sliders & TextFields").viewController(SlidersAndTextFieldsViewController.self)
		builder += ViewControllerFormItem().title("Precision Sliders").viewController(PrecisionSlidersViewController.self)
		builder += ViewControllerFormItem().title("Reload Form").viewController(ReloadingViewController.self)
		builder += ViewControllerFormItem().title("Work In Progress").viewController(WorkInProgressViewController.self)
	}
}
