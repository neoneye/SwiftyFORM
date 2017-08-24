// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class AliensViewController: FormViewController {

	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Aliens"
		builder.toolbarMode = .none
		builder += stepperForm0
		builder += button0
	}

	lazy var stepperForm0: StepperFormItem = {
		let instance = StepperFormItem()
		instance.title = "Alien encounters"
		return instance
		}()

	lazy var button0: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Submit"
		instance.action = { [weak self] in
			if let stepperValue = self?.stepperForm0.value {
				self?.form_simpleAlert("Aliens encounters", "I have encountered \(stepperValue) aliens!")
			}
		}
		return instance
		}()

}
