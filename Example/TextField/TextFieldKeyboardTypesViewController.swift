//
//  TextFieldKeyboardTypesViewController.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 18/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//
import UIKit
import SwiftyFORM

class TextFieldKeyboardTypesViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Keyboard Types"
		builder.toolbarMode = .None
		builder.demo_showInfo("Shows all the UIKeyboardType variants")
		builder += TextFieldFormItem().styleClass("align").title("ASCIICapable").placeholder("Lorem Ipsum").keyboardType(.ASCIICapable)
		builder += TextFieldFormItem().title("NumbersAndPunctuation").placeholder("123.45").keyboardType(.NumbersAndPunctuation)
		builder += TextFieldFormItem().styleClass("align").title("URL").placeholder("example.com/blog").keyboardType(.URL)
		builder += TextFieldFormItem().styleClass("align").title("NumberPad").placeholder("0123456789").keyboardType(.NumberPad)
		builder += TextFieldFormItem().styleClass("align").title("PhonePad").placeholder("+999#22;123456,27").keyboardType(.PhonePad)
		builder += TextFieldFormItem().styleClass("align").title("EmailAddress").placeholder("johnappleseed@apple.com").keyboardType(.EmailAddress)
		builder += TextFieldFormItem().styleClass("align").title("DecimalPad").placeholder("1234.5678").keyboardType(.DecimalPad)
		builder += TextFieldFormItem().styleClass("align").title("Twitter").placeholder("@user or #hashtag").keyboardType(.Twitter)
		builder += TextFieldFormItem().styleClass("align").title("WebSearch").placeholder("how to do this.").keyboardType(.WebSearch)
		builder.alignLeftElementsWithClass("align")
		builder += SectionFooterTitleFormItem().title("Footer text")
	}
}
