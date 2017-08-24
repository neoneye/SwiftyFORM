// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

struct OptionRow {
	let title: String
	let identifier: String

	init(_ title: String, _ identifier: String) {
		self.title = title
		self.identifier = identifier
	}
}

class MyOptionForm {
	let optionRows: [OptionRow]
	let vc0 = ViewControllerFormItem()

	init(optionRows: [OptionRow]) {
		self.optionRows = optionRows
	}

	func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Picker"

		configureVC0()

		for optionRow: OptionRow in optionRows {
			let option = OptionRowFormItem()
			option.title = optionRow.title
			builder.append(option)
		}

		builder.append(SectionHeaderTitleFormItem().title("Help"))
		builder.append(vc0)
	}

	func configureVC0() {
		vc0.title = "What is XYZ?"
		vc0.createViewController = { (dismissCommand: CommandProtocol) in
			let vc = EmptyViewController()
			return vc
		}
	}

}

class MaleFemaleViewController: FormViewController, SelectOptionDelegate {
	var xmyform: MyOptionForm?

	let dismissCommand: CommandProtocol

	init(dismissCommand: CommandProtocol) {
		self.dismissCommand = dismissCommand
		super.init()
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override func populate(_ builder: FormBuilder) {
		let optionRows: [OptionRow] = [
			OptionRow("Male", "male"),
			OptionRow("Female", "female"),
			OptionRow("It's complicated", "complicated")
		]

		let myform = MyOptionForm(optionRows: optionRows)

		myform.populate(builder)
		xmyform = myform
	}

	func form_willSelectOption(option: OptionRowFormItem) {
		print("select option \(option)")
		dismissCommand.execute(viewController: self, returnObject: option)
	}

}

class EmptyViewController: UIViewController {

	override func loadView() {
		self.view = UIView()
		self.view.backgroundColor = UIColor.red
	}

}
