// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class PrecisionSlidersViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Precision Sliders"
		builder.toolbarMode = .None
		
		builder += SectionHeaderTitleFormItem().title("Partial one-cell")
		builder += PrecisionSliderFormItem().minimumValue(0.25).maximumValue(0.5).value(0.45).title("One1")
		builder += PrecisionSliderFormItem().minimumValue(-0.5).maximumValue(-0.25).value(-0.45).title("One2")
		builder += PrecisionSliderFormItem().minimumValue(0.8).maximumValue(0.9).value(0.85).title("One4")
		builder += PrecisionSliderFormItem().minimumValue(-0.9).maximumValue(-0.8).value(-0.85).title("One3")
		builder += PrecisionSliderFormItem().minimumValue(0.25).maximumValue(0.5).value(0.333).title("Tiny1")
		
		builder += SectionHeaderTitleFormItem().title("Partial. No full")
		builder += PrecisionSliderFormItem().minimumValue(-0.05).maximumValue(0.05).value(0.0).title("Before after 0")
		builder += PrecisionSliderFormItem().minimumValue(-1.05).maximumValue(-0.95).value(-1.0).title("Before after -1")
		builder += PrecisionSliderFormItem().minimumValue(0.95).maximumValue(1.05).value(1.0).title("Before after +1")
		builder += PrecisionSliderFormItem().minimumValue(-0.75).maximumValue(0.75).value(0.0).title("B")
		
		builder += SectionHeaderTitleFormItem().title("Partial & full, mixed")
		builder += PrecisionSliderFormItem().minimumValue(-100.0).maximumValue(100.0).value(-100.0).title("Green")
		builder += PrecisionSliderFormItem().minimumValue(-1.333).maximumValue(1.333).value(2.0).title("A0")
		builder += PrecisionSliderFormItem().minimumValue(-3.0).maximumValue(3.0).value(0.0).title("A1")
		builder += PrecisionSliderFormItem().minimumValue(-0.25).maximumValue(3.25).value(1.5).title("Z")
		builder += PrecisionSliderFormItem().minimumValue(-0.5).maximumValue(0.5).value(0.0).title("A")
		builder += PrecisionSliderFormItem().minimumValue(-1.0).maximumValue(1.0).value(-1.0).title("C")
		builder += PrecisionSliderFormItem().minimumValue(-2.66).maximumValue(2.66).value(-2.0).title("T1")
		builder += PrecisionSliderFormItem().minimumValue(-5.11).maximumValue(5.11).value(2.0).title("T2")
		
		builder += SectionHeaderTitleFormItem().title("Partial & full, positive")
		builder += PrecisionSliderFormItem().minimumValue(0.0).maximumValue(255.0).value(255.0).title("Red")
		builder += PrecisionSliderFormItem().minimumValue(0.0).maximumValue(100.0).value(50.0).title("Water level")
		builder += PrecisionSliderFormItem().minimumValue(0.0).maximumValue(360.0).value(0.0).title("Degrees")
		builder += PrecisionSliderFormItem().minimumValue(0.0).maximumValue(3.14159).value(1.57079).title("PI")
		builder += PrecisionSliderFormItem().minimumValue(0.0).maximumValue(3.5).value(0.0).title("X")
		builder += PrecisionSliderFormItem().minimumValue(0.25).maximumValue(3.75).value(-0.5).title("Y")

		builder += SectionHeaderTitleFormItem().title("Partial & full, negative")
		builder += PrecisionSliderFormItem().minimumValue(-20.1).maximumValue(-15.0).value(-18.0).title("Negative0")
		builder += PrecisionSliderFormItem().minimumValue(-20.0).maximumValue(-15.0).value(-18.0).title("Negative1")
		builder += PrecisionSliderFormItem().minimumValue(-20.0).maximumValue(-15.1).value(-18.0).title("Negative2")
	}
}
