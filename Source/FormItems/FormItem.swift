// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit


public protocol FormItemVisitor {
	func visit(_ object: AttributedTextFormItem)
	func visit(_ object: ButtonFormItem)
	func visit(_ object: CustomFormItem)
	func visit(_ object: DatePickerFormItem)
	func visit(_ object: MetaFormItem)
	func visit(_ object: OptionPickerFormItem)
	func visit(_ object: OptionRowFormItem)
	func visit(_ object: PickerViewFormItem)
	func visit(_ object: PrecisionSliderFormItem)
	func visit(_ object: SectionFooterTitleFormItem)
	func visit(_ object: SectionFooterViewFormItem)
	func visit(_ object: SectionFormItem)
	func visit(_ object: SectionHeaderTitleFormItem)
	func visit(_ object: SectionHeaderViewFormItem)
	func visit(_ object: SegmentedControlFormItem)
	func visit(_ object: SliderFormItem)
	func visit(_ object: StaticTextFormItem)
	func visit(_ object: StepperFormItem)
	func visit(_ object: SwitchFormItem)
	func visit(_ object: TextFieldFormItem)
	func visit(_ object: TextViewFormItem)
	func visit(_ object: ViewControllerFormItem)
}

open class FormItem: NSObject {
	
	public override init() {
	}
	
	func accept(_ visitor: FormItemVisitor) {}
	
	// For serialization to json purposes, eg. "firstName"
	open var elementIdentifier: String?
	open func elementIdentifier(_ elementIdentifier: String?) -> Self {
		self.elementIdentifier = elementIdentifier
		return self
	}
	
	// For styling purposes, eg. "bottomRowInFirstSection"
	open var styleIdentifier: String?
	open func styleIdentifier(_ styleIdentifier: String?) -> Self {
		self.styleIdentifier = styleIdentifier
		return self
	}

	// For styling purposes, eg. "leftAlignedGroup0"
	open var styleClass: String?
	open func styleClass(_ styleClass: String?) -> Self {
		self.styleClass = styleClass
		return self
	}
}
