// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

class OptionListViewController: FormViewController, SelectOptionDelegate {
	typealias SelectOptionHandler = (OptionRowModel) -> Void
	let optionField: OptionPickerFormItem
	let selectOptionHandler: SelectOptionHandler

	init(optionField: OptionPickerFormItem, selectOptionHandler: @escaping SelectOptionHandler) {
		self.optionField = optionField
		self.selectOptionHandler = selectOptionHandler
		super.init()
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override func populate(_ builder: FormBuilder) {
		SwiftyFormLog("preselect option \(String(describing: optionField.selected?.title))")
		builder.navigationTitle = optionField.title
		for optionRow: OptionRowModel in optionField.options {
			let option = OptionRowFormItem()
			option.title = optionRow.title
			option.context = optionRow
			option.selected = (optionRow === optionField.selected)
			builder.append(option)
		}
	}

	func form_willSelectOption(option: OptionRowFormItem) {
		guard let selected = option.context as? OptionRowModel else {
			fatalError("Expected OptionRowModel when selecting option \(option.title)")
		}

		SwiftyFormLog("select option \(option.title)")
		selectOptionHandler(selected)
	}

}
