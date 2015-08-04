//
//  Model.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 01/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit


public protocol FormItemVisitor {
	func visitMeta(object: MetaFormItem)
	func visitStaticText(object: StaticTextFormItem)
	func visitTextField(object: TextFieldFormItem)
	func visitTextView(object: TextViewFormItem)
	func visitViewController(object: ViewControllerFormItem)
	func visitOptionPicker(object: OptionPickerFormItem)
	func visitOptionRow(object: OptionRowFormItem)
	func visitDatePicker(object: DatePickerFormItem)
	func visitButton(object: ButtonFormItem)
	func visitSwitch(object: SwitchFormItem)
	func visitStepper(object: StepperFormItem)
	func visitSlider(object: SliderFormItem)
	func visitSection(object: SectionFormItem)
	func visitSectionHeaderTitle(object: SectionHeaderTitleFormItem)
	func visitSectionHeaderView(object: SectionHeaderViewFormItem)
	func visitSectionFooterTitle(object: SectionFooterTitleFormItem)
	func visitSectionFooterView(object: SectionFooterViewFormItem)
}

public class FormItem: NSObject {
	
	public override init() {
	}
	
	func accept(visitor: FormItemVisitor) {}
	
	// For serialization to json purposes, eg. "firstName"
	public var elementIdentifier: String?
	public func elementIdentifier(elementIdentifier: String?) -> Self {
		self.elementIdentifier = elementIdentifier
		return self
	}
	
	// For styling purposes, eg. "bottomRowInFirstSection"
	public var styleIdentifier: String?
	public func styleIdentifier(styleIdentifier: String?) -> Self {
		self.styleIdentifier = styleIdentifier
		return self
	}

	// For styling purposes, eg. "leftAlignedGroup0"
	public var styleClass: String?
	public func styleClass(styleClass: String?) -> Self {
		self.styleClass = styleClass
		return self
	}
}
