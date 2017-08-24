// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class DatePickerBindingViewController: FormViewController {

	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "DatePicker & Bindings"
		builder.toolbarMode = .simple
		builder += SectionHeaderTitleFormItem(title: "Always expanded")
		builder += datePicker
		builder += incrementButton
		builder += decrementButton

		builder += SectionFormItem()
		builder += summary

		builder += SectionFormItem()
		builder += StaticTextFormItem().title("Collapse & expand")
		builder += userName
		builder += toggleDatePicker0
		builder += toggleDatePicker1
		builder += toggleDatePicker2

		updateSummary()
	}

	lazy var datePicker: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Date"
		instance.datePickerMode = .date
		instance.behavior = .expandedAlways
		instance.valueDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
		}
		return instance
	}()

	lazy var incrementButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Next Day"
		instance.action = { [weak self] in
			self?.increment()
		}
		return instance
	}()

	lazy var decrementButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Previous Day"
		instance.action = { [weak self] in
			self?.decrement()
		}
		return instance
	}()

	lazy var summary: StaticTextFormItem = {
		return StaticTextFormItem().title("Date").value("-")
	}()

	func updateSummary() {
		summary.value = "\(datePicker.value)"
	}

	func offsetDate(_ date: Date, days: Int) -> Date {
		var dateComponents = DateComponents()
		dateComponents.day = days
		let calendar = Calendar.current
		guard let resultDate = calendar.date(byAdding: dateComponents, to: date) else {
			return date
		}
		return resultDate
	}

	func increment() {
		datePicker.setValue(offsetDate(datePicker.value, days: 1), animated: true)
		updateSummary()
	}

	func decrement() {
		datePicker.setValue(offsetDate(datePicker.value, days: -1), animated: true)
		updateSummary()
	}

	// MARK: Collapse / expand

	lazy var userName: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("User Name").placeholder("required")
		instance.keyboardType = .asciiCapable
		instance.autocorrectionType = .no
		return instance
	}()

	lazy var toggleDatePicker0: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Toggle 0"
		instance.datePickerMode = .time
		instance.behavior = .expanded
		return instance
	}()

	lazy var toggleDatePicker1: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Toggle 1"
		instance.datePickerMode = .time
		instance.behavior = .collapsed
		return instance
	}()

	lazy var toggleDatePicker2: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Toggle 2"
		instance.datePickerMode = .time
		instance.behavior = .collapsed
		return instance
	}()

}
