// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

extension FormViewController {
	public func form_installSubmitButton() {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "form_submitAction:")
	}

	public func form_submitAction(sender: AnyObject?) {
		formBuilder.validateAndUpdateUI()
		let result = formBuilder.validate()
		DLog("result \(result)")
		form_showSubmitResult(result)
	}
	
	public func form_showSubmitResult(result: FormBuilder.FormValidateResult) {
		switch result {
		case .Valid:
			form_simpleAlert("Valid", "All the fields are valid")
		case let .Invalid(item, message):
			let title = item.elementIdentifier ?? "Invalid"
			form_simpleAlert(title, message)
		}
	}
}
