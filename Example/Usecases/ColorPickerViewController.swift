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
		builder += SectionFormItem()
		builder += randomizeButton
		
		updateSummary()
		updateColor()
	}
	
	lazy var slider0: PrecisionSliderFormItem = {
		let instance = PrecisionSliderFormItem().decimalPlaces(4).minimumValue(0).maximumValue(10000).value(5000)
		instance.title = "Red"
		instance.sliderDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
			self?.updateColor()
		}
		return instance
	}()
	
	lazy var slider1: PrecisionSliderFormItem = {
		let instance = PrecisionSliderFormItem().decimalPlaces(4).minimumValue(0).maximumValue(10000).value(5000)
		instance.title = "Green"
		instance.sliderDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
			self?.updateColor()
		}
		return instance
	}()
	
	lazy var slider2: PrecisionSliderFormItem = {
		let instance = PrecisionSliderFormItem().decimalPlaces(4).minimumValue(0).maximumValue(10000).value(5000)
		instance.title = "Blue"
		instance.sliderDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
			self?.updateColor()
		}
		return instance
	}()
	
	
	lazy var summary: StaticTextFormItem = {
		return StaticTextFormItem().title("Values").value("-")
	}()
	
	func updateSummary() {
		let s0 = String(format: "%.4f", slider0.actualValue)
		let s1 = String(format: "%.4f", slider1.actualValue)
		let s2 = String(format: "%.4f", slider2.actualValue)
		summary.value = "\(s0) , \(s1) , \(s2)"
	}
	
	func updateColor() {
		let color = UIColor(
			red: CGFloat(slider0.actualValue),
			green: CGFloat(slider1.actualValue),
			blue: CGFloat(slider2.actualValue),
			alpha: 1.0
		)
		view?.backgroundColor = color
	}

	lazy var randomizeButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Randomize")
		instance.action = { [weak self] in
			self?.randomize()
		}
		return instance
	}()
	
	func assignRandomValue(formItem: PrecisionSliderFormItem) {
		formItem.value = randomInt(0, 1000)
	}
	
	func randomize() {
		assignRandomValue(slider0)
		assignRandomValue(slider1)
		assignRandomValue(slider2)
		updateSummary()
		updateColor()
	}
}
