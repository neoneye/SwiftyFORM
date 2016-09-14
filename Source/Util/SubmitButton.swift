// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

extension FormViewController {
	public func form_installSubmitButton() {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(FormViewController.form_submitAction(_:)))
	}

	public func form_submitAction(_ sender: AnyObject?) {
		formBuilder.validateAndUpdateUI()
		let result = formBuilder.validate()
		SwiftyFormLog("result \(result)")
		form_showSubmitResult(result)
	}
	
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
