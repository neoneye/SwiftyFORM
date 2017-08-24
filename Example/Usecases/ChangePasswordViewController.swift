// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class ChangePasswordViewController: FormViewController {
	override func loadView() {
		super.loadView()
		form_installSubmitButton()
	}

	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Password"
		builder.toolbarMode = .simple
		builder += SectionHeaderTitleFormItem().title("Your Old Password")
		builder += passwordOld
		builder += SectionHeaderTitleFormItem().title("Your New Password")
		builder += passwordNew
		builder += passwordNewRepeated
		builder.alignLeft([passwordOld, passwordNew, passwordNewRepeated])
	}

	lazy var passwordOld: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("Old password").password().placeholder("required")
		instance.keyboardType = .numberPad
		instance.autocorrectionType = .no
		instance.validate(CharacterSetSpecification.decimalDigits, message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()

	lazy var passwordNew: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("New password").password().placeholder("required")
		instance.keyboardType = .numberPad
		instance.autocorrectionType = .no
		instance.validate(CharacterSetSpecification.decimalDigits, message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()

	lazy var passwordNewRepeated: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("Repeat password").password().placeholder("required")
		instance.keyboardType = .numberPad
		instance.autocorrectionType = .no
		instance.validate(CharacterSetSpecification.decimalDigits, message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()
}
