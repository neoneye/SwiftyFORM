// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class WorkInProgressViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Work In Progress"
		builder += ViewControllerFormItem().title("Color Picker (BETA)").viewController(ColorPickerViewController.self)
		builder += ViewControllerFormItem().title("Precision Sliders (BETA)").viewController(PrecisionSlidersViewController.self)
		builder += ViewControllerFormItem().title("Scientific slider experimental").viewController(ScientificSliderViewController.self)
	}
}
