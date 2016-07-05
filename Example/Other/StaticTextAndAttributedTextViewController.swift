// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class StaticTextAndAttributedTextViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Text"
		builder.toolbarMode = .None
		
		builder += SectionHeaderTitleFormItem(title: "Static Text")
		builder += StaticTextFormItem().title("Title 0").value("Value 0")
		builder += StaticTextFormItem().title("Title 1").value("Value 1")
		builder += StaticTextFormItem().title("Title 2").value("Value 2")
		
		builder += SectionHeaderTitleFormItem(title: "Attributed Text")
		builder += AttributedTextFormItem().title("Title 0").value("Value 0")
		builder += AttributedTextFormItem()
			.title("Title 1", [NSForegroundColorAttributeName: UIColor.grayColor()])
			.value("Value 1", [
				NSBackgroundColorAttributeName: UIColor.blackColor(),
				NSForegroundColorAttributeName: UIColor.whiteColor()
				])
		builder += AttributedTextFormItem()
			.title("Orange 🍊", [
				NSForegroundColorAttributeName: UIColor.orangeColor(),
				NSFontAttributeName: UIFont.boldSystemFontOfSize(24),
				NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
				])
			.value("Heart ❤️", [NSForegroundColorAttributeName: UIColor.redColor()])
	}
}
