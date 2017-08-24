// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class StaticTextAndAttributedTextViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Text"
		builder.toolbarMode = .none

		builder += SectionHeaderTitleFormItem(title: "Static Text")
		builder += StaticTextFormItem().title("Title 0").value("Value 0")
		builder += StaticTextFormItem().title("Title 1").value("Value 1")
		builder += StaticTextFormItem().title("Title 2").value("Value 2")

		builder += SectionHeaderTitleFormItem(title: "Attributed Text")
		builder += AttributedTextFormItem().title("Title 0").value("Value 0")
		builder += AttributedTextFormItem()
			.title("Title 1", [NSForegroundColorAttributeName: UIColor.gray as AnyObject])
			.value("Value 1", [
				NSBackgroundColorAttributeName: UIColor.black as AnyObject,
				NSForegroundColorAttributeName: UIColor.white as AnyObject
				])
		builder += AttributedTextFormItem()
			.title("Orange 🍊", [
				NSForegroundColorAttributeName: UIColor.orange as AnyObject,
				NSFontAttributeName: UIFont.boldSystemFont(ofSize: 24) as AnyObject,
				NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue as AnyObject
				])
			.value("Heart ❤️", [NSForegroundColorAttributeName: UIColor.red as AnyObject])
	}
}
