// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import SwiftyFORM

class NoHeaderViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "No Header"
		
		let section0 = SectionFormItem()
		section0.sectionType = .none
		builder += section0

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
