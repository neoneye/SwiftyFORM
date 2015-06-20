//
//  SlidersViewController.swift
//  Example
//
//  Created by Simon Strandgaard on 20-06-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import UIKit
import SwiftyFORM

class SlidersViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Sliders"
		builder.toolbarMode = .None
		builder += SectionHeaderTitleFormItem().title("Sliders")
		builder += SliderFormItem().minimumValue(-1.0).maximumValue(1.0).value(-0.5)
		builder += SliderFormItem().minimumValue(-100.0).maximumValue(100.0).value(42)
		builder += SliderFormItem().minimumValue(0.0).maximumValue(100.0).value(80)
	}
}
