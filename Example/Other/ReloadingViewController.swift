// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class ReloadingViewController: FormViewController {
	var populateCount = 0

	override func populate(_ builder: FormBuilder) {
		populateCount += 1

		builder.navigationTitle = "Reload Form"
		builder.toolbarMode = .none

		builder += SectionHeaderTitleFormItem().title("Action")
		builder += reloadButton

		builder += SectionHeaderTitleFormItem().title("Populate")
		builder += StaticTextFormItem().title("Number of reloads").value(String(populateCount))

		if populateCount & 1 == 1 {
			builder += SectionHeaderTitleFormItem().title("Good")
			builder += StaticTextFormItem().title("Cure cancer")
			builder += StaticTextFormItem().title("World peace")
			builder += StaticTextFormItem().title("Science")
		} else {
			builder += SectionHeaderTitleFormItem().title("Bad")
			builder += StaticTextFormItem().title("Ignorance")
			builder += StaticTextFormItem().title("Dictatorship")
			builder += StaticTextFormItem().title("Polution")
		}
	}

	lazy var reloadButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Reload Form"
		instance.action = { [weak self] in
			self?.reloadForm()
		}
		return instance
	}()
}
