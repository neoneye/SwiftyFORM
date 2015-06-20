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
		builder += StepperFormItem().title("Number Of Cats")
	}
	
}
