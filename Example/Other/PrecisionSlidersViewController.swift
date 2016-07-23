// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class PrecisionSlidersViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Precision Sliders"
		builder.toolbarMode = .None
		
		builder += SectionHeaderTitleFormItem().title("Partial one-cell")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(250).maximumValue(500).value(450).title("A 0.25 0.5")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-500).maximumValue(-250).value(-450).title("B -0.5 -0.25")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(800).maximumValue(900).value(850).title("C 0.8 0.9")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-900).maximumValue(-800).value(-850).title("D -0.9 -0.8")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(499).maximumValue(501).value(500).title("E 0.499 0.501")
		
		builder += SectionHeaderTitleFormItem().title("Partial. No full")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-50).maximumValue(50).value(0).title("A -0.05 0.05")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-3_050).maximumValue(-2_950).value(-3_000).title("B -3.05 -2.95")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(2_950).maximumValue(3_050).value(3_000).title("C 2.95 3.05")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-750).maximumValue(750).value(0).title("D -0.75 0.75")

		builder += SectionHeaderTitleFormItem().title("Partial & full, mixed")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-100_000).maximumValue(100_000).value(-100_000).title("A -100 100")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-1_333).maximumValue(1_333).value(0).title("B -1.333 1.333")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-3_000).maximumValue(3_000).value(0).title("C -3 3")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-250).maximumValue(3_250).value(1_500).title("D -0.25 3.25")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-500).maximumValue(500).value(0).title("E -0.5 0.5")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-1_000).maximumValue(1_000).value(0).title("F -1 1")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-2_666).maximumValue(2_666).value(-2_000).title("G -2.666 2.666")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-5_220).maximumValue(5_220).value(0).title("H -5.22 5.22")

		builder += SectionHeaderTitleFormItem().title("Partial & full, positive")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(0).maximumValue(255_000).value(255_000).title("A 0 255")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(0).maximumValue(100_000).value(50_000).title("B 0 100")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(0).maximumValue(360_000).value(0).title("C 0 360")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(0).maximumValue(3_141).value(1_570).title("D 0 PI")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(0).maximumValue(3_500).value(0).title("E 0 3.5")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(250).maximumValue(3_750).value(0).title("F 0.25 3.75")

		builder += SectionHeaderTitleFormItem().title("Partial & full, negative")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-20_100).maximumValue(-15_000).value(-18_000).title("A -20.1 -15")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-20_000).maximumValue(-15_000).value(-18_000).title("B -20 -15")
		builder += PrecisionSliderFormItem().decimalPlaces(3).minimumValue(-20_000).maximumValue(-15_100).value(-18_000).title("C -20 -15.1")
	}
}
