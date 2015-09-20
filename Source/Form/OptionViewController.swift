// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

class OptionViewController: FormViewController, SelectOptionDelegate {
	let dismissCommand: CommandProtocol
	let optionField: OptionPickerFormItem
	
	init(dismissCommand: CommandProtocol, optionField: OptionPickerFormItem) {
		self.dismissCommand = dismissCommand
		self.optionField = optionField
		super.init()
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func populate(builder: FormBuilder) {
		DLog("preselect option \(optionField.selected?.title)")
		builder.navigationTitle = optionField.title
		for optionRow: OptionRowModel in optionField.options {
			let option = OptionRowFormItem()
			option.title(optionRow.title)
			option.context = optionRow
			option.selected = (optionRow === optionField.selected)
			builder.append(option)
		}
	}
	
	func form_willSelectOption(option: OptionRowFormItem) {
		DLog("select option \(option.title)")
		dismissCommand.execute(self, returnObject: option.context)
	}

}
