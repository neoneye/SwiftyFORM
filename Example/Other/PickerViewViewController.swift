// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class PickerViewViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "PickerViews"
		builder.toolbarMode = .None
		
		builder += SectionHeaderTitleFormItem().title("PickerView")
		builder += picker0
		builder += picker1
		builder += picker2
	}
	
	lazy var picker0: PickerViewFormItem = {
		let instance = PickerViewFormItem().title("1 component").behavior(.ExpandedAlways)
		instance.pickerTitles = [["c0 r0", "c0 r1"]]
		return instance
	}()

	lazy var picker1: PickerViewFormItem = {
		let instance = PickerViewFormItem().title("2 components").behavior(.ExpandedAlways)
		instance.pickerTitles = [["c0 r0", "c0 r1"], ["c1 r0", "c1 r1"]]
		return instance
	}()

	lazy var picker2: PickerViewFormItem = {
		let instance = PickerViewFormItem().title("3 components").behavior(.ExpandedAlways)
		instance.pickerTitles = [["c0 r0", "c0 r1"], ["c1 r0", "c1 r1"], ["c2 r0", "c2 r1"]]
		return instance
	}()
}
