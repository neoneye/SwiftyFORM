// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import SwiftyFORM

class PickerViewViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "PickerViews"
		builder += SectionHeaderTitleFormItem().title("PickerView")
		builder += picker0
		builder += picker1
		builder += picker2
		builder += SectionHeaderTitleFormItem().title("Misc")
		builder += summary
		builder += randomizeButton

		updateSummary()
	}

	lazy var picker0: PickerViewFormItem = {
		let instance = PickerViewFormItem().title("1 component").behavior(.expanded)
		instance.pickerTitles = [["0", "1", "2", "3", "4", "5", "6"]]
		instance.valueDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
		}
		return instance
	}()

	lazy var picker1: PickerViewFormItem = {
		let instance = PickerViewFormItem().title("2 components")
		instance.pickerTitles = [["00", "01", "02", "03"], ["10", "11", "12", "13", "14"]]
		instance.humanReadableValueSeparator = " :: "
		instance.valueDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
		}
		return instance
	}()

	lazy var picker2: PickerViewFormItem = {
		let instance = PickerViewFormItem().title("3 components")
		instance.pickerTitles = [["00", "01", "02", "03"], ["10", "11", "12"], ["20", "21", "22", "23", "24"]]
		instance.humanReadableValueSeparator = " % "
		instance.valueDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
		}
		return instance
	}()

	lazy var summary: StaticTextFormItem = {
		return StaticTextFormItem().title("Values").value("-")
	}()

	func updateSummary() {
		let v0 = picker0.value
		let v1 = picker1.value
		let v2 = picker2.value
		summary.value = "\(v0) , \(v1) , \(v2)"
	}

	lazy var randomizeButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Randomize"
		instance.action = { [weak self] in
			self?.randomize()
		}
		return instance
	}()

	func assignRandomValues(_ pickerView: PickerViewFormItem) {
		var selectedRows = [Int]()
		for rows in pickerView.pickerTitles {
			if rows.count > 0 {
				selectedRows.append(randomInt(0, rows.count-1))
			} else {
				selectedRows.append(-1)
			}
		}
		pickerView.setValue(selectedRows, animated: true)
	}

	func randomize() {
		assignRandomValues(picker0)
		assignRandomValues(picker1)
		assignRandomValues(picker2)
		updateSummary()
	}
}
