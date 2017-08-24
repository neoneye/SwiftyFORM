// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

class ObtainTitleWidth: FormItemVisitor {
	var width: CGFloat = 0

	func visit(object: TextFieldFormItem) {
		width = object.obtainTitleWidth()
	}

	func visit(object: AttributedTextFormItem) {}
	func visit(object: ButtonFormItem) {}
	func visit(object: CustomFormItem) {}
	func visit(object: DatePickerFormItem) {}
	func visit(object: MetaFormItem) {}
	func visit(object: OptionPickerFormItem) {}
	func visit(object: OptionRowFormItem) {}
	func visit(object: PickerViewFormItem) {}
	func visit(object: PrecisionSliderFormItem) {}
	func visit(object: SectionFooterTitleFormItem) {}
	func visit(object: SectionFooterViewFormItem) {}
	func visit(object: SectionFormItem) {}
	func visit(object: SectionHeaderTitleFormItem) {}
	func visit(object: SectionHeaderViewFormItem) {}
	func visit(object: SegmentedControlFormItem) {}
	func visit(object: SliderFormItem) {}
	func visit(object: StaticTextFormItem) {}
	func visit(object: StepperFormItem) {}
	func visit(object: SwitchFormItem) {}
	func visit(object: TextViewFormItem) {}
	func visit(object: ViewControllerFormItem) {}
}

class AssignTitleWidth: FormItemVisitor {
	fileprivate var width: CGFloat = 0

	init(width: CGFloat) {
		self.width = width
	}

	func visit(object: TextFieldFormItem) {
		object.assignTitleWidth(width)
	}

	func visit(object: AttributedTextFormItem) {}
	func visit(object: ButtonFormItem) {}
	func visit(object: CustomFormItem) {}
	func visit(object: DatePickerFormItem) {}
	func visit(object: MetaFormItem) {}
	func visit(object: OptionPickerFormItem) {}
	func visit(object: OptionRowFormItem) {}
	func visit(object: PickerViewFormItem) {}
	func visit(object: PrecisionSliderFormItem) {}
	func visit(object: SectionFooterTitleFormItem) {}
	func visit(object: SectionFooterViewFormItem) {}
	func visit(object: SectionFormItem) {}
	func visit(object: SectionHeaderTitleFormItem) {}
	func visit(object: SectionHeaderViewFormItem) {}
	func visit(object: SegmentedControlFormItem) {}
	func visit(object: SliderFormItem) {}
	func visit(object: StaticTextFormItem) {}
	func visit(object: StepperFormItem) {}
	func visit(object: SwitchFormItem) {}
	func visit(object: TextViewFormItem) {}
	func visit(object: ViewControllerFormItem) {}
}
