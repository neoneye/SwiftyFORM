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
		
		updateSummary()
	}
	
	
	lazy var datePicker: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Date")
		instance.datePickerMode = .Date
		instance.behavior = .ExpandedAlways
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
		return StaticTextFormItem().title("Date").value("-")
	}()
	
	func updateSummary() {
		summary.value = "\(datePicker.value)"
	}

	
	func offsetDate(date: NSDate, days: Int) -> NSDate? {
		let dateComponents = NSDateComponents()
		dateComponents.day = days
		let calendar = NSCalendar.currentCalendar()
		return calendar.dateByAddingComponents(dateComponents, toDate: date, options: NSCalendarOptions(rawValue: 0))
	}
	
	func increment() {
		guard let date = datePicker.value else {
			datePicker.value = NSDate()
			return
		}
		datePicker.setValue(offsetDate(date, days: 1), animated: true)
	}

	func decrement() {
		guard let date = datePicker.value else {
			datePicker.value = NSDate()
			return
		}
		datePicker.setValue(offsetDate(date, days: -1), animated: true)
	}
	
}
