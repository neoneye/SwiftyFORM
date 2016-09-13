// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class DumpVisitor: FormItemVisitor {
	fileprivate typealias StringToAnyObject = [String: AnyObject]
	
	public init() {
	}
	
	class func dump(_ prettyPrinted: Bool = true, items: [FormItem]) -> Data {
		var result = [StringToAnyObject]()
		var rowNumber: Int = 0
		for item in items {
			let dumpVisitor = DumpVisitor()
			item.accept(dumpVisitor)
			
			
			var dict = StringToAnyObject()
			dict["row"] = rowNumber as AnyObject?
			
			let validateVisitor = ValidateVisitor()
			item.accept(validateVisitor)
			switch validateVisitor.result {
			case .valid:
				dict["validate-status"] = "ok" as AnyObject?
			case .hardInvalid(let message):
				dict["validate-status"] = "hard-invalid" as AnyObject?
				dict["validate-message"] = message
			case .softInvalid(let message):
				dict["validate-status"] = "soft-invalid" as AnyObject?
				dict["validate-message"] = message
			}
			
			dict.update(dumpVisitor.dict)
			
			result.append(dict)
			rowNumber += 1
		}
		
		do {
			let options: JSONSerialization.WritingOptions = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
			let data = try JSONSerialization.data(withJSONObject: result, options: options)
			return data
		} catch _ {
		}
		
		return Data()
	}
	
	fileprivate var dict = StringToAnyObject()
	
	open func visit(_ object: MetaFormItem) {
		dict["class"] = "MetaFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["value"] = object.value
	}

	open func visit(_ object: CustomFormItem) {
		dict["class"] = "CustomFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
	
	open func visit(_ object: StaticTextFormItem) {
		dict["class"] = "StaticTextFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["value"] = object.value as AnyObject?
	}

	open func visit(_ object: AttributedTextFormItem) {
		dict["class"] = "AttributedTextFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title?.string as AnyObject?
		dict["value"] = object.value?.string as AnyObject?
	}
	
	open func visit(_ object: TextFieldFormItem) {
		dict["class"] = "TextFieldFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["value"] = object.value as AnyObject?
		dict["placeholder"] = object.placeholder as AnyObject?
	}
	
	open func visit(_ object: TextViewFormItem) {
		dict["class"] = "TextViewFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["value"] = object.value as AnyObject?
	}
	
	open func visit(_ object: ViewControllerFormItem) {
		dict["class"] = "ViewControllerFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}
	
	open func visit(_ object: OptionPickerFormItem) {
		dict["class"] = "OptionPickerFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["placeholder"] = object.placeholder as AnyObject?
		dict["value"] = object.selected?.title as AnyObject?
	}
	
	func convertOptionalDateToJSON(_ date: Date?) -> AnyObject {
		if let date = date {
			return date.description as AnyObject
		}
		return NSNull()
	}
	
	open func visit(_ object: DatePickerFormItem) {
		dict["class"] = "DatePickerFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["date"] = convertOptionalDateToJSON(object.value as Date)
		dict["datePickerMode"] = object.datePickerMode.description as AnyObject?
		dict["locale"] = object.locale ?? NSNull()
		dict["minimumDate"] = convertOptionalDateToJSON(object.minimumDate as Date?)
		dict["maximumDate"] = convertOptionalDateToJSON(object.minimumDate as Date?)
	}
	
	open func visit(_ object: ButtonFormItem) {
		dict["class"] = "ButtonFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}
	
	open func visit(_ object: OptionRowFormItem) {
		dict["class"] = "OptionRowFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["state"] = object.selected as AnyObject?
	}

	open func visit(_ object: SwitchFormItem) {
		dict["class"] = "SwitchFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["value"] = object.value as AnyObject?
	}

	open func visit(_ object: StepperFormItem) {
		dict["class"] = "StepperFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}
	
	open func visit(_ object: SliderFormItem) {
		dict["class"] = "SliderFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["value"] = object.value as AnyObject?
		dict["minimumValue"] = object.minimumValue as AnyObject?
		dict["maximumValue"] = object.maximumValue as AnyObject?
	}
	
	open func visit(_ object: PrecisionSliderFormItem) {
		dict["class"] = "PrecisionSliderFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["value"] = object.value as AnyObject?
		dict["minimumValue"] = object.minimumValue as AnyObject?
		dict["maximumValue"] = object.maximumValue as AnyObject?
		dict["decimalPlaces"] = object.decimalPlaces as AnyObject?
	}
	
	open func visit(_ object: SectionFormItem) {
		dict["class"] = "SectionFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
	
	open func visit(_ object: SectionHeaderTitleFormItem) {
		dict["class"] = "SectionHeaderTitleFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}
	
	open func visit(_ object: SectionHeaderViewFormItem) {
		dict["class"] = "SectionHeaderViewFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
	
	open func visit(_ object: SectionFooterTitleFormItem) {
		dict["class"] = "SectionFooterTitleFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}

	open func visit(_ object: SectionFooterViewFormItem) {
		dict["class"] = "SectionFooterViewFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}

	open func visit(_ object: SegmentedControlFormItem) {
		dict["class"] = "SegmentedControlFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
	
	open func visit(_ object: PickerViewFormItem) {
		dict["class"] = "PickerViewFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
}
