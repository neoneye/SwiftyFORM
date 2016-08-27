// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class PickerViewViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Precision Sliders"
		builder.toolbarMode = .None
		
		builder += SectionHeaderTitleFormItem().title("PickerView")
		builder += PickerViewFormItem().title("Hello")
	}
}
