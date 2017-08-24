// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class RateAppViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Rate"
		builder.toolbarMode = .none
		builder.demo_showInfo("Rate this app")
		builder += SectionHeaderTitleFormItem().title("Is it good?")
		builder += goodSlider
		builder += SectionHeaderTitleFormItem().title("Is the look ok?")
		builder += lookSlider
		builder += SectionHeaderTitleFormItem().title("Thank you")
		builder += submitButton
	}

	lazy var goodSlider: SliderFormItem = {
		let instance = SliderFormItem()
		instance.minimumValue(-100.0).maximumValue(100.0).value(0)
		return instance
		}()

	lazy var lookSlider: SliderFormItem = {
		let instance = SliderFormItem()
		instance.minimumValue(-100.0).maximumValue(100.0).value(0)
		return instance
		}()

	lazy var submitButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Submit My Rating"
		instance.action = { [weak self] in
			self?.submitMyRating()
		}
		return instance
		}()

	func submitMyRating() {
		self.form_simpleAlert("Submit Rating", "Button clicked")
	}
}
