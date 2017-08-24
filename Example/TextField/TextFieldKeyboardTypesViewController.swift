// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class TextFieldKeyboardTypesViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Keyboard Types"
		builder.toolbarMode = .none
		builder.demo_showInfo("Shows all the UIKeyboardType variants")
		builder += TextFieldFormItem().styleClass("align").title("ASCIICapable").placeholder("Lorem Ipsum").keyboardType(.asciiCapable)
		builder += TextFieldFormItem().title("NumbersAndPunctuation").placeholder("123.45").keyboardType(.numbersAndPunctuation)
		builder += TextFieldFormItem().styleClass("align").title("URL").placeholder("example.com/blog").keyboardType(.URL)
		builder += TextFieldFormItem().styleClass("align").title("NumberPad").placeholder("0123456789").keyboardType(.numberPad)
		builder += TextFieldFormItem().styleClass("align").title("PhonePad").placeholder("+999#22;123456,27").keyboardType(.phonePad)
		builder += TextFieldFormItem().styleClass("align").title("EmailAddress").placeholder("johnappleseed@apple.com").keyboardType(.emailAddress)
		builder += TextFieldFormItem().styleClass("align").title("DecimalPad").placeholder("1234.5678").keyboardType(.decimalPad)
		builder += TextFieldFormItem().styleClass("align").title("Twitter").placeholder("@user or #hashtag").keyboardType(.twitter)
		builder += TextFieldFormItem().styleClass("align").title("WebSearch").placeholder("how to do this.").keyboardType(.webSearch)
		builder.alignLeftElementsWithClass("align")
		builder += SectionFooterTitleFormItem().title("Footer text")
	}
}
