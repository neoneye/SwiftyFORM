// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import SwiftyFORM

class Tutorial0_StaticText_ViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder += StaticTextFormItem().title("Hello").value("World")
	}
}
