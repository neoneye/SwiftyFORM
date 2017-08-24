// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import SwiftyFORM

class HeaderFooterViewController: FormViewController {

	let headerView0 = SectionHeaderViewFormItem()
	let footerView0 = SectionFooterViewFormItem()

	override func populate(_ builder: FormBuilder) {
		configureHeaderView0()
		configureFooterView0()

		builder.navigationTitle = "Header & Footer"
		builder.demo_showInfo("Demonstration of\nsection headers\nand section footers")
		builder += SectionHeaderTitleFormItem().title("Standard Header Title")
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += SectionFooterTitleFormItem().title("Standard Footer Title")
		builder += headerView0
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += footerView0
		builder += SectionHeaderTitleFormItem().title("Line 1: Standard Header Title\nLine 2: Standard Header Title\nLine 3: Standard Header Title")
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += SectionFooterTitleFormItem(title: "Line 1: Standard Footer Title\nLine 2: Standard Footer Title\nLine 3: Standard Footer Title")
	}

	func configureHeaderView0() {
		headerView0.viewBlock = {
			return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 75), text: "Custom\nHeader\nView")
		}
	}

	func configureFooterView0() {
		footerView0.viewBlock = {
			return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 75), text: "Custom\nFooter\nView")
		}
	}
}
