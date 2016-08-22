// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import Foundation

public class DumpVisitor: FormItemVisitor {
	private typealias StringToAnyObject = [String: AnyObject]
	
	public init() {
	}
	
	class func dump(prettyPrinted: Bool = true, items: [FormItem]) -> NSData {
		var result = [StringToAnyObject]()
		var rowNumber: Int = 0
		for item in items {
			let dumpVisitor = DumpVisitor()
			item.accept(dumpVisitor)
			
			
			var dict = StringToAnyObject()
			dict["row"] = rowNumber
			
			let validateVisitor = ValidateVisitor()
			item.accept(validateVisitor)
			switch validateVisitor.result {
			case .Valid:
				dict["validate-status"] = "ok"
			case .HardInvalid(let message):
				dict["validate-status"] = "hard-invalid"
				dict["validate-message"] = message
			case .SoftInvalid(let message):
				dict["validate-status"] = "soft-invalid"
				dict["validate-message"] = message
			}
			
			dict.update(dumpVisitor.dict)
			
			result.append(dict)
			rowNumber += 1
		}
		
		do {
			let options: NSJSONWritingOptions = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : []
			let data = try NSJSONSerialization.dataWithJSONObject(result, options: options)
			return data
		} catch _ {
		}
		
		return NSData()
	}
	
	private var dict = StringToAnyObject()
	
	public func visit(object: MetaFormItem) {
		dict["class"] = "MetaFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["value"] = object.value
	}

	public func visit(object: CustomFormItem) {
		dict["class"] = "CustomFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}
	
	public func visit(object: StaticTextFormItem) {
		dict["class"] = "StaticTextFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["value"] = object.value
	}

	public func visit(object: AttributedTextFormItem) {
		dict["class"] = "AttributedTextFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title?.string
		dict["value"] = object.value?.string
	}
	
	public func visit(object: TextFieldFormItem) {
		dict["class"] = "TextFieldFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["value"] = object.value
		dict["placeholder"] = object.placeholder
	}
	
	public func visit(object: TextViewFormItem) {
		dict["class"] = "TextViewFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["value"] = object.value
	}
	
	public func visit(object: ViewControllerFormItem) {
		dict["class"] = "ViewControllerFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}
	
	public func visit(object: OptionPickerFormItem) {
		dict["class"] = "OptionPickerFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["placeholder"] = object.placeholder
		dict["value"] = object.selected?.title
	}
	
	func convertOptionalDateToJSON(date: NSDate?) -> AnyObject {
		if let date = date {
			return date.description
		}
		return NSNull()
	}
	
	public func visit(object: DatePickerFormItem) {
		dict["class"] = "DatePickerFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["date"] = convertOptionalDateToJSON(object.value)
		dict["datePickerMode"] = object.datePickerMode.description
		dict["locale"] = object.locale ?? NSNull()
		dict["minimumDate"] = convertOptionalDateToJSON(object.minimumDate)
		dict["maximumDate"] = convertOptionalDateToJSON(object.minimumDate)
	}
	
	public func visit(object: ButtonFormItem) {
		dict["class"] = "ButtonFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}
	
	public func visit(object: OptionRowFormItem) {
		dict["class"] = "OptionRowFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["state"] = object.selected
	}

	public func visit(object: SwitchFormItem) {
		dict["class"] = "SwitchFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["value"] = object.value
	}

	public func visit(object: StepperFormItem) {
		dict["class"] = "StepperFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}
	
	public func visit(object: SliderFormItem) {
		dict["class"] = "SliderFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["value"] = object.value
		dict["minimumValue"] = object.minimumValue
		dict["maximumValue"] = object.maximumValue
	}
	
	public func visit(object: PrecisionSliderFormItem) {
		dict["class"] = "PrecisionSliderFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["value"] = object.value
		dict["minimumValue"] = object.minimumValue
		dict["maximumValue"] = object.maximumValue
		dict["decimalPlaces"] = object.decimalPlaces
	}
	
	public func visit(object: SectionFormItem) {
		dict["class"] = "SectionFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}
	
	public func visit(object: SectionHeaderTitleFormItem) {
		dict["class"] = "SectionHeaderTitleFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}
	
	public func visit(object: SectionHeaderViewFormItem) {
		dict["class"] = "SectionHeaderViewFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}
	
	public func visit(object: SectionFooterTitleFormItem) {
		dict["class"] = "SectionFooterTitleFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}

	public func visit(object: SectionFooterViewFormItem) {
		dict["class"] = "SectionFooterViewFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}

	public func visit(object: SegmentedControlFormItem) {
		dict["class"] = "SegmentedControlFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}
}
