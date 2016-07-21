// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class ColorPickerViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Color picker"
		builder.toolbarMode = .None
		
		builder += SectionHeaderTitleFormItem().title("Components")
		builder += slider0
		builder += slider1
		builder += slider2
		
		builder += SectionHeaderTitleFormItem().title("Summary")
		builder += summary
		
		updateSummary()
		updateColor()
	}
	
	lazy var slider0: PrecisionSliderFormItem = {
		let instance = PrecisionSliderFormItem().minimumValue(0.0).maximumValue(1.0).value(0.5)
		instance.title = "Red"
		instance.sliderDidChangeBlock = { [weak self] (value: Double) in
			self?.updateSummary()
			self?.updateColor()
		}
		return instance
	}()
	
	lazy var slider1: PrecisionSliderFormItem = {
		let instance = PrecisionSliderFormItem().minimumValue(0.0).maximumValue(1.0).value(0.5)
		instance.title = "Green"
		instance.sliderDidChangeBlock = { [weak self] (value: Double) in
			self?.updateSummary()
			self?.updateColor()
		}
		return instance
	}()
	
	lazy var slider2: PrecisionSliderFormItem = {
		let instance = PrecisionSliderFormItem().minimumValue(0.0).maximumValue(1.0).value(0.5)
		instance.title = "Blue"
		instance.sliderDidChangeBlock = { [weak self] (value: Double) in
			self?.updateSummary()
			self?.updateColor()
		}
		return instance
	}()
	
	
	lazy var summary: StaticTextFormItem = {
		return StaticTextFormItem().title("Values").value("-")
	}()
	
	func updateSummary() {
		let s0 = String(format: "%.3f", slider0.value)
		let s1 = String(format: "%.3f", slider1.value)
		let s2 = String(format: "%.3f", slider2.value)
		summary.value = "\(s0) , \(s1) , \(s2)"
	}
	
	func updateColor() {
		let color = UIColor(
			red: CGFloat(slider0.value),
			green: CGFloat(slider1.value),
			blue: CGFloat(slider2.value),
			alpha: 1.0
		)
		view?.backgroundColor = color
	}
}
