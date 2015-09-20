// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

class ObtainTitleWidth: FormItemVisitor {
	var width: CGFloat = 0
	
	func visitMeta(object: MetaFormItem) {}
	func visitCustom(object: CustomFormItem) {}
	func visitStaticText(object: StaticTextFormItem) {}
	
	func visitTextField(object: TextFieldFormItem) {
		width = object.obtainTitleWidth()
	}
	
	func visitTextView(object: TextViewFormItem) {}
	func visitViewController(object: ViewControllerFormItem) {}
	func visitOptionPicker(object: OptionPickerFormItem) {}
	func visitDatePicker(object: DatePickerFormItem) {}
	func visitButton(object: ButtonFormItem) {}
	func visitOptionRow(object: OptionRowFormItem) {}
	func visitSwitch(object: SwitchFormItem) {}
	func visitStepper(object: StepperFormItem) {}
	func visitSlider(object: SliderFormItem) {}
	func visitSection(object: SectionFormItem) {}
	func visitSectionHeaderTitle(object: SectionHeaderTitleFormItem) {}
	func visitSectionHeaderView(object: SectionHeaderViewFormItem) {}
	func visitSectionFooterTitle(object: SectionFooterTitleFormItem) {}
	func visitSectionFooterView(object: SectionFooterViewFormItem) {}
}

class AssignTitleWidth: FormItemVisitor {
	private var width: CGFloat = 0
	
	init(width: CGFloat) {
		self.width = width
	}
	
	func visitMeta(object: MetaFormItem) {}
	func visitCustom(object: CustomFormItem) {}
	func visitStaticText(object: StaticTextFormItem) {}
	
	func visitTextField(object: TextFieldFormItem) {
		object.assignTitleWidth(width)
	}
	
	func visitTextView(object: TextViewFormItem) {}
	func visitViewController(object: ViewControllerFormItem) {}
	func visitOptionPicker(object: OptionPickerFormItem) {}
	func visitDatePicker(object: DatePickerFormItem) {}
	func visitButton(object: ButtonFormItem) {}
	func visitOptionRow(object: OptionRowFormItem) {}
	func visitSwitch(object: SwitchFormItem) {}
	func visitStepper(object: StepperFormItem) {}
	func visitSlider(object: SliderFormItem) {}
	func visitSection(object: SectionFormItem) {}
	func visitSectionHeaderTitle(object: SectionHeaderTitleFormItem) {}
	func visitSectionHeaderView(object: SectionHeaderViewFormItem) {}
	func visitSectionFooterTitle(object: SectionFooterTitleFormItem) {}
	func visitSectionFooterView(object: SectionFooterViewFormItem) {}
}
