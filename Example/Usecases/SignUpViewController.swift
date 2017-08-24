// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class SignUpViewController: FormViewController {
	override func loadView() {
		super.loadView()
		form_installSubmitButton()
	}

	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Sign Up"
		builder.toolbarMode = .simple
		builder.demo_showInfo("SocialNetwork 123\nSign up form")
		builder += SectionHeaderTitleFormItem().title("Details")
		builder += userName
		builder += password
		builder += email
		builder += maleOrFemale
		builder += birthday
		builder.alignLeft([userName, password, email])
		builder += SectionFormItem()
		builder += subscribeToNewsletter
		builder += SectionFooterTitleFormItem().title("There is no way to unsubscribe our service")
		builder += metaData
		builder += SectionHeaderTitleFormItem().title("Buttons")
		builder += randomizeButton
		builder += jsonButton
	}

	lazy var userName: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("User Name").placeholder("required")
		instance.keyboardType = .asciiCapable
		instance.autocorrectionType = .no
		instance.validate(CharacterSetSpecification.lowercaseLetters, message: "Must be lowercase letters")
		instance.submitValidate(CountSpecification.min(6), message: "Length must be minimum 6 letters")
		instance.validate(CountSpecification.max(8), message: "Length must be maximum 8 letters")
		return instance
		}()

	lazy var maleOrFemale: ViewControllerFormItem = {
		let instance = ViewControllerFormItem()
		instance.title("Male or Female").placeholder("required")
		instance.createViewController = { (dismissCommand: CommandProtocol) in
			let vc = MaleFemaleViewController(dismissCommand: dismissCommand)
			return vc
		}
		instance.willPopViewController = { (context: ViewControllerFormItemPopContext) in
			if let x = context.returnedObject as? SwiftyFORM.OptionRowFormItem {
				context.cell.detailTextLabel?.text = x.title
			} else {
				context.cell.detailTextLabel?.text = nil
			}
		}
		return instance
		}()

	lazy var password: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("PIN Code").password().placeholder("required")
		instance.keyboardType = .numberPad
		instance.autocorrectionType = .no
		instance.validate(CharacterSetSpecification.decimalDigits, message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()

	lazy var email: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("Email").placeholder("johndoe@example.com")
		instance.keyboardType = .emailAddress
		instance.submitValidate(CountSpecification.min(6), message: "Length must be minimum 6 letters")
		instance.validate(CountSpecification.max(60), message: "Length must be maximum 60 letters")
		instance.softValidate(EmailSpecification(), message: "Must be a valid email address")
		return instance
		}()

	func offsetDate(_ date: Date, years: Int) -> Date {
		var dateComponents = DateComponents()
		dateComponents.year = years
		let calendar = Calendar.current
		guard let resultDate = calendar.date(byAdding: dateComponents, to: date) else {
			return date
		}
		return resultDate
	}

	lazy var birthday: DatePickerFormItem = {
		let today = Date()
		let instance = DatePickerFormItem()
		instance.title = "Birthday"
		instance.datePickerMode = .date
		instance.minimumDate = self.offsetDate(today, years: -150)
		instance.maximumDate = today
		return instance
		}()

	lazy var subscribeToNewsletter: SwitchFormItem = {
		let instance = SwitchFormItem()
		instance.title = "Subscribe to newsletter"
		instance.value = true
		return instance
		}()

	lazy var metaData: MetaFormItem = {
		let instance = MetaFormItem()
		var dict = [String: AnyObject?]()
		dict["key0"] = "I'm hidden text" as AnyObject?
		dict["key1"] = "I'm included when exporting to JSON" as AnyObject?
		dict["key2"] = "Can be used to pass extra info along with the JSON" as AnyObject?
		instance.value(dict as AnyObject?).elementIdentifier("metaData")
		return instance
		}()

	lazy var randomizeButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Randomize"
		instance.action = { [weak self] in
			self?.randomize()
		}
		return instance
		}()

	func pickRandom(_ strings: [String]) -> String {
		if strings.count == 0 {
			return ""
		}
		let i = randomInt(0, strings.count - 1)
		return strings[i]
	}

	func pickRandomDate() -> Date {
		let i = randomInt(20, 60)
		let today = Date()
		return offsetDate(today, years: -i)
	}

	func pickRandomBoolean() -> Bool {
		let i = randomInt(0, 1)
		return i == 0
	}

	func randomize() {
		userName.value = pickRandom(["john", "jane", "steve", "bill", "einstein", "newton"])
		password.value = pickRandom(["1234", "0000", "111111", "abc", "111122223333"])
		email.value = pickRandom(["hello@example.com", "hi@example.com", "feedback@example.com", "unsubscribe@example.com", "not-a-valid-email"])
		birthday.value = pickRandomDate()
		subscribeToNewsletter.value = pickRandomBoolean()
	}

	lazy var jsonButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "View JSON"
		instance.action = { [weak self] in
			if let vc = self {
				DebugViewController.showJSON(vc, jsonData: vc.formBuilder.dump())
			}
		}
		return instance
		}()

}
