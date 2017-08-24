// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class WorkInProgressViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Work In Progress"
		builder += ViewControllerFormItem().title("Scientific slider experimental").viewController(ScientificSliderViewController.self)
	}
}
