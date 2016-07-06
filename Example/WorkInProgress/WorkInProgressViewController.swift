// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class WorkInProgressViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Work In Progress"
		builder += ViewControllerFormItem().title("Scientific slider").viewController(ScientificSliderViewController.self)
	}
}
