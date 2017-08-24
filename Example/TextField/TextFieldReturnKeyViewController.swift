// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class TextFieldReturnKeyViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Return Key"
		builder.toolbarMode = .simple
		builder.demo_showInfo("Shows all the UIReturnKeyType variants")
		builder += TextFieldFormItem().styleClass("align").title("Default").returnKeyType(.default).placeholder("Return (gray)")
		builder += TextFieldFormItem().styleClass("align").title("Go").returnKeyType(.go).placeholder("Go (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Google").returnKeyType(.google).placeholder("Search (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Join").returnKeyType(.join).placeholder("Join (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Next").returnKeyType(.next).placeholder("Next (gray)")
		builder += TextFieldFormItem().styleClass("align").title("Route").returnKeyType(.route).placeholder("Route (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Search").returnKeyType(.search).placeholder("Search (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Send").returnKeyType(.send).placeholder("Send (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Yahoo").returnKeyType(.yahoo).placeholder("Search (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Done").returnKeyType(.done).placeholder("Done (blue)")
		builder += TextFieldFormItem().styleClass("align").title("EmergencyCall").returnKeyType(.emergencyCall).placeholder("Emergency Call (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Continue").returnKeyType(.continue).placeholder("Continue (gray)")
		builder.alignLeftElementsWithClass("align")
	}
}
