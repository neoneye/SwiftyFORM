// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class DatePickerInitialValueViewController: FormViewController {
	
	lazy var datePicker_time_noValue: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Time")
		instance.datePickerMode = .Time
		return instance
		}()
	
	lazy var datePicker_date_noValue: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Date")
		instance.datePickerMode = .Date
		return instance
		}()
	
	lazy var datePicker_dateAndTime_noValue: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("DateAndTime")
		instance.datePickerMode = .DateAndTime
		return instance
		}()
	
	lazy var datePicker_time_value: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Time")
		instance.datePickerMode = .Time
		instance.value = NSDate(timeIntervalSinceNow: (5 * 60 * 60 + 5 * 60 + 5))
		return instance
		}()
	
	lazy var datePicker_date_value: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Date")
		instance.datePickerMode = .Date
		instance.value = NSDate(timeIntervalSinceNow: 51 * 24 * 60 * 60)
		return instance
		}()
	
	lazy var datePicker_dateAndTime_value: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("DateAndTime")
		instance.datePickerMode = .DateAndTime
		instance.value = NSDate(timeIntervalSinceNow: 51 * 24 * 60 * 60)
		return instance
		}()
	
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "DatePicker & Value"
		builder.toolbarMode = .Simple
		builder.demo_showInfo("Demonstration of\nUIDatePicker with initial value")
		builder += SectionHeaderTitleFormItem().title("Without initial date")
		builder += datePicker_time_noValue
		builder += datePicker_date_noValue
		builder += datePicker_dateAndTime_noValue
		builder += SectionHeaderTitleFormItem().title("With initial date")
		builder += datePicker_time_value
		builder += datePicker_date_value
		builder += datePicker_dateAndTime_value
	}
	
}
