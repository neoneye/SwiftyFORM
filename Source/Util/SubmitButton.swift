// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

extension FormViewController {
	/// Installs a "Submit" button in the navigation bar.
	/// When tapped it validates if the form satisfies its specifications.
	/// This is only supposed to be used during development,
	/// as a quick way to verify if the form is valid or not.
	public func form_installSubmitButton() {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(FormViewController.form_submitAction(_:)))
	}

	/// Used internally by the `form_installSubmitButton()` function
	@objc public func form_submitAction(_ sender: AnyObject?) {
		formBuilder.validateAndUpdateUI()
		let result = formBuilder.validate()
		SwiftyFormLog("result \(result)")
		form_showSubmitResult(result)
	}

	/// Used internally by the `form_installSubmitButton()` function
	public func form_showSubmitResult(_ result: FormBuilder.FormValidateResult) {
		switch result {
		case .valid:
			form_simpleAlert("Valid", "All the fields are valid")
		case let .invalid(item, message):
			let title = item.elementIdentifier ?? "Invalid"
			form_simpleAlert(title, message)
		}
	}
}
