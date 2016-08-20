// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class DatePickerBindingViewController: FormViewController {
	
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "DatePicker & Bindings"
		builder.toolbarMode = .Simple
		builder += SectionHeaderTitleFormItem(title: "Manipulate the date")
		builder += datePicker
		builder += incrementButton
		builder += decrementButton

		builder += SectionFormItem()
		builder += summary

		builder += SectionFormItem()
		builder += toggleDatePicker0
		builder += toggleDatePicker1
		builder += toggleDatePicker2
		
		updateSummary()
	}
	
	lazy var datePicker: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Date")
		instance.datePickerMode = .Date
		instance.behavior = .ExpandedAlways
		instance.valueDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
		}
		return instance
	}()
	
	lazy var incrementButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Next Day")
		instance.action = { [weak self] in
			self?.increment()
		}
		return instance
	}()
	
	lazy var decrementButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Previous Day")
		instance.action = { [weak self] in
			self?.decrement()
		}
		return instance
	}()
	
	lazy var summary: StaticTextFormItem = {
		return StaticTextFormItem().title("NSDate").value("-")
	}()
	
	func updateSummary() {
		summary.value = "\(datePicker.value)"
	}
	
	func offsetDate(date: NSDate, days: Int) -> NSDate {
		let dateComponents = NSDateComponents()
		dateComponents.day = days
		let calendar = NSCalendar.currentCalendar()
		guard let resultDate = calendar.dateByAddingComponents(dateComponents, toDate: date, options: NSCalendarOptions(rawValue: 0)) else {
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

	lazy var toggleDatePicker0: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Toggle 0")
		instance.datePickerMode = .Time
		instance.behavior = .Expanded
		return instance
	}()
	
	lazy var toggleDatePicker1: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Toggle 1")
		instance.datePickerMode = .Time
		instance.behavior = .Collapsed
		return instance
	}()
	
	lazy var toggleDatePicker2: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Toggle 2")
		instance.datePickerMode = .Time
		instance.behavior = .Collapsed
		return instance
	}()
	
}
