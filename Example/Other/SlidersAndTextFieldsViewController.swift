// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class SlidersAndTextFieldsViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Sliders and TextFields"
		builder.toolbarMode = .simple
		builder += textField0
		builder += PrecisionSliderFormItem().decimalPlaces(0).minimumValue(-100).maximumValue(100).value(0).title("Slider 0").shouldCollapseWhenResigning()
		builder += textField1
		builder += PrecisionSliderFormItem().decimalPlaces(0).minimumValue(-100).maximumValue(100).value(0).title("Slider 1").shouldCollapseWhenResigning()
		builder += textField2
	}

	lazy var textField0: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("TextField 0").placeholder("required")
		instance.keyboardType = .asciiCapable
		instance.autocorrectionType = .no
		return instance
	}()

	lazy var textField1: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("TextField 1").placeholder("required")
		instance.keyboardType = .asciiCapable
		instance.autocorrectionType = .no
		return instance
	}()

	lazy var textField2: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("TextField 2").placeholder("required")
		instance.keyboardType = .asciiCapable
		instance.autocorrectionType = .no
		return instance
	}()
}
