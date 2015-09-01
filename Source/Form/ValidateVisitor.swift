//
//  ValidateVisitor.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 23/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import Foundation

class ValidateVisitor: NSObject, FormItemVisitor {
	var result = ValidateResult.Valid
	
	func visitMeta(object: MetaFormItem) {}
	func visitCustom(object: CustomFormItem) {}
	func visitStaticText(object: StaticTextFormItem) {}
	
	func visitTextField(object: TextFieldFormItem) {
		result = object.submitValidateValueText()
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
