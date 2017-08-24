// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class DatePickerLocaleViewController: FormViewController {

	lazy var datePicker_time_currentLocale: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Time"
		instance.datePickerMode = .time
		return instance
		}()

	lazy var datePicker_date_currentLocale: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Date"
		instance.datePickerMode = .date
		return instance
	}()

	lazy var datePicker_dateAndTime_currentLocale: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "DateAndTime"
		instance.datePickerMode = .dateAndTime
		return instance
		}()

	lazy var datePicker_time_da_DK: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Time"
		instance.datePickerMode = .time
		instance.locale = Locale(identifier: "da_DK")
		return instance
		}()

	lazy var datePicker_date_da_DK: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Date"
		instance.datePickerMode = .date
		instance.locale = Locale(identifier: "da_DK")
		return instance
		}()

	lazy var datePicker_dateAndTime_da_DK: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "DateAndTime"
		instance.datePickerMode = .dateAndTime
		instance.locale = Locale(identifier: "da_DK")
		return instance
		}()

	lazy var datePicker_time_zh_CN: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Time"
		instance.datePickerMode = .time
		instance.locale = Locale(identifier: "zh_CN")
		return instance
		}()

	lazy var datePicker_date_zh_CN: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Date"
		instance.datePickerMode = .date
		instance.locale = Locale(identifier: "zh_CN")
		return instance
		}()

	lazy var datePicker_dateAndTime_zh_CN: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "DateAndTime"
		instance.datePickerMode = .dateAndTime
		instance.locale = Locale(identifier: "zh_CN")
		return instance
		}()

	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "DatePicker & Locale"
		builder.toolbarMode = .simple
		builder.demo_showInfo("Demonstration of\nUIDatePicker with locale")
		builder += SectionHeaderTitleFormItem(title: "Current locale")
		builder += datePicker_time_currentLocale
		builder += datePicker_date_currentLocale
		builder += datePicker_dateAndTime_currentLocale
		builder += SectionHeaderTitleFormItem(title: "da_DK")
		builder += datePicker_time_da_DK
		builder += datePicker_date_da_DK
		builder += datePicker_dateAndTime_da_DK
		builder += SectionHeaderTitleFormItem(title: "zh_CN")
		builder += datePicker_time_zh_CN
		builder += datePicker_date_zh_CN
		builder += datePicker_dateAndTime_zh_CN
	}
}
