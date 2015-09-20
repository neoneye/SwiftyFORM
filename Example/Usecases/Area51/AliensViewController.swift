//
//  AliensViewController.swift
//  Example
//
//  Created by Simon Strandgaard on 20-09-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import UIKit
import SwiftyFORM

class AliensViewController: FormViewController {

	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Aliens"
		builder.toolbarMode = .None
		builder += stepperForm0
		builder += button0
	}
	
	lazy var stepperForm0: StepperFormItem = {
		let instance = StepperFormItem()
		instance.title("Alien encounters")
		return instance
		}()
	
	lazy var button0: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Submit")
		instance.action = { [weak self] in
			if let stepperValue = self?.stepperForm0.value {
				self?.form_simpleAlert("Aliens encounters", "I have encountered \(stepperValue) aliens!")
			}
		}
		return instance
		}()

}
