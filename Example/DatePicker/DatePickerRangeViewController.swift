// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class DatePickerRangeViewController: FormViewController {
	lazy var datePicker_time_min: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Time"
		instance.datePickerMode = .time
		// -(5 * 60 * 60 + 5 * 60 + 5) == -18305
		instance.minimumDate = Date(timeIntervalSinceNow: -18305)
		return instance
		}()

	lazy var datePicker_date_min: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Date"
		instance.datePickerMode = .date
		// -5 * 24 * 60 * 60 == -432000
		instance.minimumDate = Date(timeIntervalSinceNow: -432000)
		return instance
		}()

	lazy var datePicker_dateAndTime_min: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "DateAndTime"
		instance.datePickerMode = .dateAndTime
		// -5 * 24 * 60 * 60 == -432000
		instance.minimumDate = Date(timeIntervalSinceNow: -432000)
		return instance
		}()

	lazy var datePicker_time_max: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Time"
		instance.datePickerMode = .time
		// 5 * 60 * 60 + 5 * 60 + 5 == 18305
		instance.maximumDate = Date(timeIntervalSinceNow: 18305)
		return instance
		}()

	lazy var datePicker_date_max: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Date"
		instance.datePickerMode = .date
		// 5 * 24 * 60 * 60 == 432000
		instance.maximumDate = Date(timeIntervalSinceNow: 432000)
		return instance
		}()

	lazy var datePicker_dateAndTime_max: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "DateAndTime"
		instance.datePickerMode = .dateAndTime
		// 5 * 24 * 60 * 60 == 432000
		instance.maximumDate = Date(timeIntervalSinceNow: 432000)
		return instance
		}()

	lazy var datePicker_time_minmax: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Time"
		instance.datePickerMode = .time
		// 5 * 60 * 60 + 5 * 60 + 5 == 18305
		instance.minimumDate = Date(timeIntervalSinceNow: -18305)
		instance.maximumDate = Date(timeIntervalSinceNow: 18305)
		return instance
		}()

	lazy var datePicker_date_minmax: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Date"
		instance.datePickerMode = .date
		// 5 * 24 * 60 * 60 == 432000
		instance.minimumDate = Date(timeIntervalSinceNow: -432000)
		instance.maximumDate = Date(timeIntervalSinceNow: 432000)
		return instance
		}()

	lazy var datePicker_dateAndTime_minmax: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "DateAndTime"
		instance.datePickerMode = .dateAndTime
		// 5 * 24 * 60 * 60 == 432000
		instance.minimumDate = Date(timeIntervalSinceNow: -432000)
		instance.maximumDate = Date(timeIntervalSinceNow: 432000)
		return instance
		}()

	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "DatePicker & Range"
		builder.toolbarMode = .simple
		builder.demo_showInfo("Demonstration of\nUIDatePicker with range")
		builder += SectionHeaderTitleFormItem().title("Minimum limit")
		builder += datePicker_time_min
		builder += datePicker_date_min
		builder += datePicker_dateAndTime_min
		builder += SectionHeaderTitleFormItem().title("Maximum limit")
		builder += datePicker_time_max
		builder += datePicker_date_max
		builder += datePicker_dateAndTime_max
		builder += SectionHeaderTitleFormItem().title("Minimum and maximum limits")
		builder += datePicker_time_minmax
		builder += datePicker_date_minmax
		builder += datePicker_dateAndTime_minmax
	}

}
