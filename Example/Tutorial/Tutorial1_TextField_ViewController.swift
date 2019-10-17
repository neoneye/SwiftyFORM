// MIT license. Copyright (c) 2019 SwiftyFORM. All rights reserved.
import SwiftyFORM

class Tutorial1_TextField_ViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder += TextFieldFormItem().title("Email").placeholder("Please specify").keyboardType(.emailAddress)
	}
}
