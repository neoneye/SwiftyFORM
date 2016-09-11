// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class DatePickerBindingViewController: FormViewController {
	
	// transition from hidden to visible works
	// TODO: however transition from visible to hidden, is broken, why doesn't the header dissappear?
	var showHeader = false
	
	func reload() {
		// TODO: move to FormViewController
		formBuilder.removeAll()
		populate(formBuilder)
		title = formBuilder.navigationTitle
		dataSource = formBuilder.result(self)
		tableView.dataSource = dataSource
		tableView.delegate = dataSource
		tableView.reloadData()
		
		debugPrint(dataSource!)
	}
	
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "DatePicker & Bindings"
		builder.toolbarMode = .Simple
		
		let section0 = SectionFormItem()
		if showHeader {
			section0.sectionType = .Default
		} else {
			section0.sectionType = .None
		}
		
		builder += section0
		builder += toggleHeaderButton
//		builder += SectionHeaderTitleFormItem(title: "Always expanded")
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
	
	lazy var toggleHeaderButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Toggle")
		instance.action = { [weak self] in
			self?.toggleAction()
		}
		return instance
	}()
	
	func toggleAction() {
		showHeader = !showHeader
		reload()
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

	// MARK: Collapse / expand
	
	lazy var userName: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("User Name").placeholder("required")
		instance.keyboardType = .ASCIICapable
		instance.autocorrectionType = .No
		return instance
	}()
	
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
