//
//  WorkInProgressViewController.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 16/12/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit
import SwiftyFORM

class WorkInProgressViewController: FormViewController {
	
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Work In Progress"
		builder += stepperForm0
		builder += button0
	}

      lazy var stepperForm0: StepperFormItem = {
        let instance = StepperFormItem()
        instance.title("Number of Cats")

        return instance
        }()

      lazy var button0: ButtonFormItem = {
        let instance = ButtonFormItem()
        instance.title("Button 0")
        instance.action = { [weak self] in
          if let stepperValue = self?.stepperForm0.value {
            self?.form_simpleAlert("Button 0", "There are \(stepperValue) cats!")
          }
        }
        return instance
        }()
	
}
