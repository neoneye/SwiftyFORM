// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import SwiftyFORM

class NoHeaderViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "No Header"
		builder.suppressHeaderForFirstSection = true

		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += SectionFormItem()
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += SectionFormItem()
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
		builder += StaticTextFormItem().title("Empty Row")
	}
}
