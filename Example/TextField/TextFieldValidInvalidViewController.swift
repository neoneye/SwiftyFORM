// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class TextFieldValidInvalidViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Valid & Invalid"
		builder.toolbarMode = .simple
		builder.demo_showInfo("Shows layouts variants\nof the text field cell\nwhen valid and when invalid")
		builder += SectionHeaderTitleFormItem().title("padding before")
		builder += StaticTextFormItem().title("Padding 1")
		builder += StaticTextFormItem().title("Padding 2")
		builder += StaticTextFormItem().title("Padding 3")
		builder += StaticTextFormItem().title("Padding 4")
		builder += StaticTextFormItem().title("Padding 6")
		builder += StaticTextFormItem().title("Padding 7")
		builder += SectionHeaderTitleFormItem().title("valid / invalid")
		let t0 = builder.append(TextFieldFormItem().title("Valid").placeholder("no message shown"))
		let t1 = builder.append(TextFieldFormItem().title("Invalid 1").placeholder("one line")
			.validate(FalseSpecification(), message: "Line 1 of 1"))
		let t2 = builder.append(TextFieldFormItem().title("Invalid 2").placeholder("two lines")
			.validate(FalseSpecification(), message: "Line 1 of 2\nLine 2 of 2"))
		let t3 = builder.append(TextFieldFormItem().title("Invalid 3").placeholder("three lines")
			.validate(FalseSpecification(), message: "Line 1 of 3\nLine 2 of 3\nLine 3 of 3"))
		builder.alignLeft([t0, t1, t2, t3])
		builder += SectionFooterTitleFormItem().title("Footer text")
		builder += SectionHeaderTitleFormItem().title("padding after")
		builder += StaticTextFormItem().title("Padding 1")
		builder += StaticTextFormItem().title("Padding 2")
		builder += StaticTextFormItem().title("Padding 3")
		builder += StaticTextFormItem().title("Padding 4")
		builder += StaticTextFormItem().title("Padding 5")
	}
}
