// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class SettingsViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Settings"
		builder.toolbarMode = .none
		builder += SectionHeaderTitleFormItem().title("Options")
		builder += server
		builder += theme
		builder += logging
		builder += SectionHeaderTitleFormItem().title("Actions")
		builder += resetUserDefaultsButton
		builder += deleteCacheButton
	}

	lazy var server: OptionPickerFormItem = {
		let instance = OptionPickerFormItem()
		instance.title("Server").placeholder("required")
		instance.append("Production").append("Staging1").append("Staging2")
		instance.selectOptionWithTitle("Production")
		return instance
	}()

	lazy var theme: OptionPickerFormItem = {
		let instance = OptionPickerFormItem()
		instance.title("Theme").placeholder("required")
		instance.append("Bright").append("Hipster").append("Dark")
		instance.selectOptionWithTitle("Bright")
		return instance
	}()

	lazy var logging: OptionPickerFormItem = {
		let instance = OptionPickerFormItem()
		instance.title("Logging").placeholder("required")
		instance.append("Disabled").append("Compact").append("Verbose")
		instance.selectOptionWithTitle("Verbose")
		return instance
	}()

	lazy var resetUserDefaultsButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Reset UserDefaults"
		instance.action = { [weak self] in
			self?.form_simpleAlert("Reset UserDefaults", "Button clicked")
		}
		return instance
	}()

	lazy var deleteCacheButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Delete Cache"
		instance.action = { [weak self] in
			self?.form_simpleAlert("Delete Cache", "Button clicked")
		}
		return instance
	}()
}
