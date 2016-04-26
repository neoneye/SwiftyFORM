// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class SlidersViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Sliders"
		builder.toolbarMode = .None
		
		builder += SectionHeaderTitleFormItem().title("Sliders")
		builder += slider0
		builder += slider1
		builder += slider2

		builder += SectionHeaderTitleFormItem().title("Summary")
		builder += summary
		
		updateSummary()
	}
	
	lazy var slider0: SliderFormItem = {
		let instance = SliderFormItem().minimumValue(-1.0).maximumValue(1.0).value(-0.5)
		instance.sliderDidChangeBlock = { [weak self] (value: Float) in
			self?.updateSummary()
		}
		return instance
	}()

	lazy var slider1: SliderFormItem = {
		let instance = SliderFormItem().minimumValue(-100.0).maximumValue(100.0).value(42)
		instance.sliderDidChangeBlock = { [weak self] (value: Float) in
			self?.updateSummary()
		}
		return instance
	}()
	
	lazy var slider2: SliderFormItem = {
		let instance = SliderFormItem().minimumValue(0.0).maximumValue(100.0).value(80)
		instance.sliderDidChangeBlock = { [weak self] (value: Float) in
			self?.updateSummary()
		}
		return instance
	}()
	
	lazy var summary: StaticTextFormItem = {
		return StaticTextFormItem().title("Values").value("-")
	}()
	
	func updateSummary() {
		summary.value = "\(slider0.value) : \(slider1.value) : \(slider2.value)"
	}
}
