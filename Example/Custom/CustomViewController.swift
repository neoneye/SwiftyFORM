// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class CustomViewController: FormViewController {

	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Custom cells"
		builder.toolbarMode = .simple
		builder.demo_showInfo("Demonstration of\ncustom cells using\nCustomFormItem")

		builder += SectionHeaderTitleFormItem(title: "World news")
		let loaderItem0 = CustomFormItem()
		loaderItem0.createCell = { _ in
			return try LoadingCell.createCell()
		}
		builder += loaderItem0

		builder += SectionHeaderTitleFormItem().title("Technology news")
		let loaderItem1 = CustomFormItem()
		loaderItem1.createCell = { _ in
			return try LoadingCell.createCell()
		}
		builder += loaderItem1

		builder += SectionHeaderTitleFormItem().title("Game news")
		let loaderItem2 = CustomFormItem()
		loaderItem2.createCell = { _ in
			return try LoadingCell.createCell()
		}
		builder += loaderItem2

		builder += SectionHeaderTitleFormItem().title("Fashion news")
		let loaderItem3 = CustomFormItem()
		loaderItem3.createCell = { _ in
			return try LoadingCell.createCell()
		}
		builder += loaderItem3

		builder += SectionHeaderTitleFormItem().title("Biz news")
		let loaderItem4 = CustomFormItem()
		loaderItem4.createCell = { _ in
			return try LoadingCell.createCell()
		}
		builder += loaderItem4
	}

}
