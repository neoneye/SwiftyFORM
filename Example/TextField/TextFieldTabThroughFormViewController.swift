// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class TextFieldTabThroughFormViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Tab Through Form"
		builder.toolbarMode = .Simple
		builder.demo_showInfo("Tab through all the fields\nusing a physical keyboard\nDoesn't wrap around")
		builder += TextFieldFormItem().styleClass("align1").title("Field A").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field B").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field C").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field D").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field E").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field F").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field G").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field H").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field I").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field J").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field K").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field L").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field M").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field N").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field O").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field P").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field Q").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field R").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field S").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field T").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field U").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field V").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field W").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field X").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field Y").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().styleClass("align1").title("Field Z").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder.alignLeftElementsWithClass("align1")
		builder += SectionFormItem()
	}
}
