// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class TextFieldEditingEndViewController: FormViewController {
    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "Editing End"
        builder.demo_showInfo("Shows an alert after editing has finished")
        builder += SectionHeaderTitleFormItem().title("Write a new nickname")
        builder += textField
    }

	lazy var textField: TextFieldFormItem = {
		var instance = TextFieldFormItem()
		instance.title = "Nickname"
		instance.placeholder = "Example EvilBot1337"
		instance.autocorrectionType = .no
		instance.textEditingEndBlock = { [weak self] value in
			self?.presentAlert(value)
		}
		return instance
	}()
	
	func presentAlert(_ value: String) {
		let alert = UIAlertController(title: "Editing End Callback", message: "Value is '\(value)'", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
		present(alert, animated: true)
	}
}
