// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

class ReloadPersistentValidationStateVisitor: FormItemVisitor {
	
	class func validateAndUpdateUI(_ items: [FormItem]) {
		let visitor = ReloadPersistentValidationStateVisitor()
		for item in items {
			item.accept(visitor)
		}
	}
	
	func visit(_ object: TextFieldFormItem) {
		object.reloadPersistentValidationState()
	}
	
	func visit(_ object: AttributedTextFormItem) {}
	func visit(_ object: ButtonFormItem) {}
	func visit(_ object: CustomFormItem) {}
	func visit(_ object: DatePickerFormItem) {}
	func visit(_ object: MetaFormItem) {}
	func visit(_ object: OptionPickerFormItem) {}
	func visit(_ object: OptionRowFormItem) {}
	func visit(_ object: PickerViewFormItem) {}
	func visit(_ object: PrecisionSliderFormItem) {}
	func visit(_ object: SectionFooterTitleFormItem) {}
	func visit(_ object: SectionFooterViewFormItem) {}
	func visit(_ object: SectionFormItem) {}
	func visit(_ object: SectionHeaderTitleFormItem) {}
	func visit(_ object: SectionHeaderViewFormItem) {}
	func visit(_ object: SegmentedControlFormItem) {}
	func visit(_ object: SliderFormItem) {}
	func visit(_ object: StaticTextFormItem) {}
	func visit(_ object: StepperFormItem) {}
	func visit(_ object: SwitchFormItem) {}
	func visit(_ object: TextViewFormItem) {}
	func visit(_ object: ViewControllerFormItem) {}
}
