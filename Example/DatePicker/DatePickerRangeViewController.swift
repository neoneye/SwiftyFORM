//
//  DatePickerRangeViewController.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 07/12/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit
import SwiftyFORM

class DatePickerRangeViewController: FormViewController {

	lazy var datePicker_time_min: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Time")
		instance.datePickerMode = .Time
		instance.minimumDate = NSDate(timeIntervalSinceNow: -(5 * 60 * 60 + 5 * 60 + 5))
		return instance
		}()
	
	lazy var datePicker_date_min: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Date")
		instance.datePickerMode = .Date
		instance.minimumDate = NSDate(timeIntervalSinceNow: -5 * 24 * 60 * 60)
		return instance
		}()
	
	lazy var datePicker_dateAndTime_min: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("DateAndTime")
		instance.datePickerMode = .DateAndTime
		instance.minimumDate = NSDate(timeIntervalSinceNow: -5 * 24 * 60 * 60)
		return instance
		}()
	
	lazy var datePicker_time_max: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Time")
		instance.datePickerMode = .Time
		instance.maximumDate = NSDate(timeIntervalSinceNow: (5 * 60 * 60 + 5 * 60 + 5))
		return instance
		}()
	
	lazy var datePicker_date_max: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Date")
		instance.datePickerMode = .Date
		instance.maximumDate = NSDate(timeIntervalSinceNow: 5 * 24 * 60 * 60)
		return instance
		}()
	
	lazy var datePicker_dateAndTime_max: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("DateAndTime")
		instance.datePickerMode = .DateAndTime
		instance.maximumDate = NSDate(timeIntervalSinceNow: 5 * 24 * 60 * 60)
		return instance
		}()
	
	lazy var datePicker_time_minmax: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Time")
		instance.datePickerMode = .Time
		instance.minimumDate = NSDate(timeIntervalSinceNow: -(5 * 60 * 60 + 5 * 60 + 5))
		instance.maximumDate = NSDate(timeIntervalSinceNow: (5 * 60 * 60 + 5 * 60 + 5))
		return instance
		}()
	
	lazy var datePicker_date_minmax: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Date")
		instance.datePickerMode = .Date
		instance.minimumDate = NSDate(timeIntervalSinceNow: -5 * 24 * 60 * 60)
		instance.maximumDate = NSDate(timeIntervalSinceNow: 5 * 24 * 60 * 60)
		return instance
		}()
	
	lazy var datePicker_dateAndTime_minmax: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("DateAndTime")
		instance.datePickerMode = .DateAndTime
		instance.minimumDate = NSDate(timeIntervalSinceNow: -5 * 24 * 60 * 60)
		instance.maximumDate = NSDate(timeIntervalSinceNow: 5 * 24 * 60 * 60)
		return instance
		}()
	
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "DatePicker & Range"
		builder.toolbarMode = .Simple
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
