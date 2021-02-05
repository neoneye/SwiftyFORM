// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class LabViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Lab"
        builder.demo_showInfo("Welcome to my lab!")
		builder += ViewControllerFormItem().title("Scientific slider").viewController(ScientificSliderViewController.self)
	}
}
