// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class TextFieldReturnKeyViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Return Key"
		builder.toolbarMode = .Simple
		builder.demo_showInfo("Shows all the UIReturnKeyType variants")
		builder += TextFieldFormItem().styleClass("align").title("Default").returnKeyType(.Default).placeholder("Return (gray)")
		builder += TextFieldFormItem().styleClass("align").title("Go").returnKeyType(.Go).placeholder("Go (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Google").returnKeyType(.Google).placeholder("Search (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Join").returnKeyType(.Join).placeholder("Join (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Next").returnKeyType(.Next).placeholder("Next (gray)")
		builder += TextFieldFormItem().styleClass("align").title("Route").returnKeyType(.Route).placeholder("Route (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Search").returnKeyType(.Search).placeholder("Search (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Send").returnKeyType(.Send).placeholder("Send (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Yahoo").returnKeyType(.Yahoo).placeholder("Search (blue)")
		builder += TextFieldFormItem().styleClass("align").title("Done").returnKeyType(.Done).placeholder("Done (blue)")
		builder += TextFieldFormItem().styleClass("align").title("EmergencyCall").returnKeyType(.EmergencyCall).placeholder("Emergency Call (blue)")
		builder.alignLeftElementsWithClass("align")
	}
}
