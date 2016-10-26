// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public class DumpVisitor: FormItemVisitor {
	fileprivate typealias StringToAnyObject = [String: AnyObject?]
	
	public init() {
	}
	
	class func dump(_ prettyPrinted: Bool = true, items: [FormItem]) -> Data {
		var result = [StringToAnyObject]()
		var rowNumber: Int = 0
		for item in items {
			let dumpVisitor = DumpVisitor()
			item.accept(visitor: dumpVisitor)
			
			
			var dict = StringToAnyObject()
			dict["row"] = rowNumber as AnyObject?
			
			let validateVisitor = ValidateVisitor()
			item.accept(visitor: validateVisitor)
			switch validateVisitor.result {
			case .valid:
				dict["validate-status"] = "ok" as AnyObject?
			case .hardInvalid(let message):
				dict["validate-status"] = "hard-invalid" as AnyObject?
				dict["validate-message"] = message as AnyObject?
			case .softInvalid(let message):
				dict["validate-status"] = "soft-invalid" as AnyObject?
				dict["validate-message"] = message as AnyObject?
			}
			
			dict.update(dumpVisitor.dict)
			
			result.append(dict)
			rowNumber += 1
		}
		
		return JSONHelper.convert(object: result as AnyObject?, prettyPrinted: prettyPrinted)
	}
	
	fileprivate var dict = StringToAnyObject()
	
	public func visit(object: MetaFormItem) {
		dict["class"] = "MetaFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["value"] = object.value
	}

	public func visit(object: CustomFormItem) {
		dict["class"] = "CustomFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
	
	public func visit(object: StaticTextFormItem) {
		dict["class"] = "StaticTextFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["value"] = object.value as AnyObject?
	}

	public func visit(object: AttributedTextFormItem) {
		dict["class"] = "AttributedTextFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title?.string as AnyObject?
		dict["value"] = object.value?.string as AnyObject?
	}
	
	public func visit(object: TextFieldFormItem) {
		dict["class"] = "TextFieldFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["value"] = object.value as AnyObject?
		dict["placeholder"] = object.placeholder as AnyObject?
	}
	
	public func visit(object: TextViewFormItem) {
		dict["class"] = "TextViewFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["value"] = object.value as AnyObject?
	}
	
	public func visit(object: ViewControllerFormItem) {
		dict["class"] = "ViewControllerFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}
	
	public func visit(object: OptionPickerFormItem) {
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
	
	public func visit(object: DatePickerFormItem) {
		dict["class"] = "DatePickerFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["date"] = convertOptionalDateToJSON(object.value as Date)
		dict["datePickerMode"] = object.datePickerMode.description as AnyObject?
		dict["locale"] = object.locale as AnyObject?
		dict["minimumDate"] = convertOptionalDateToJSON(object.minimumDate as Date?)
		dict["maximumDate"] = convertOptionalDateToJSON(object.minimumDate as Date?)
	}
	
	public func visit(object: ButtonFormItem) {
		dict["class"] = "ButtonFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}
	
	public func visit(object: OptionRowFormItem) {
		dict["class"] = "OptionRowFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["state"] = object.selected as AnyObject?
	}

	public func visit(object: SwitchFormItem) {
		dict["class"] = "SwitchFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
		dict["value"] = object.value as AnyObject?
	}

	public func visit(object: StepperFormItem) {
		dict["class"] = "StepperFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}
	
	public func visit(object: SliderFormItem) {
		dict["class"] = "SliderFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["value"] = object.value as AnyObject?
		dict["minimumValue"] = object.minimumValue as AnyObject?
		dict["maximumValue"] = object.maximumValue as AnyObject?
	}
	
	public func visit(object: PrecisionSliderFormItem) {
		dict["class"] = "PrecisionSliderFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["value"] = object.value as AnyObject?
		dict["minimumValue"] = object.minimumValue as AnyObject?
		dict["maximumValue"] = object.maximumValue as AnyObject?
		dict["decimalPlaces"] = object.decimalPlaces as AnyObject?
	}
	
	public func visit(object: SectionFormItem) {
		dict["class"] = "SectionFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
	
	public func visit(object: SectionHeaderTitleFormItem) {
		dict["class"] = "SectionHeaderTitleFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}
	
	public func visit(object: SectionHeaderViewFormItem) {
		dict["class"] = "SectionHeaderViewFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
	
	public func visit(object: SectionFooterTitleFormItem) {
		dict["class"] = "SectionFooterTitleFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
		dict["title"] = object.title as AnyObject?
	}

	public func visit(object: SectionFooterViewFormItem) {
		dict["class"] = "SectionFooterViewFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}

	public func visit(object: SegmentedControlFormItem) {
		dict["class"] = "SegmentedControlFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
	
	public func visit(object: PickerViewFormItem) {
		dict["class"] = "PickerViewFormItem" as AnyObject?
		dict["elementIdentifier"] = object.elementIdentifier as AnyObject?
		dict["styleIdentifier"] = object.styleIdentifier as AnyObject?
		dict["styleClass"] = object.styleClass as AnyObject?
	}
}


internal struct JSONHelper {

	static func process(_ objectOrNil: AnyObject?) -> AnyObject {
		guard let object: AnyObject = objectOrNil else {
			return NSNull()
		}
		if object is NSNull {
			return NSNull()
		}
		
		if let dict = object as? NSDictionary {
			var result = [String: AnyObject]()
			for (keyObject, valueObject) in dict {
				guard let key = keyObject as? String else {
					print("Expected string for key, skipping key: \(keyObject)")
					continue
				}
				result[key] = process(valueObject as AnyObject?)
			}
			return result as AnyObject
		}
		if let array = object as? NSArray {
			var result = [AnyObject]()
			for valueObject in array {
				let item = process(valueObject as AnyObject?)
				result.append(item)
			}
			return result as AnyObject
		}
		if let item = object as? String {
			return item as AnyObject
		}
		if let item = object as? Bool {
			return item as AnyObject
		}
		if let item = object as? Int {
			return item as AnyObject
		}
		if let item = object as? UInt {
			return item as AnyObject
		}
		if let item = object as? Float {
			return item as AnyObject
		}
		if let item = object as? Double {
			return item as AnyObject
		}
		if let item = object as? NSNumber {
			return item as AnyObject
		}

		guard object as! _OptionalNilComparisonType != AnyObject?.none else {
			return NSNull()
		}

		print("unknown item: \(object)  \(object.self)")
		
		return NSNull()
	}

	
	static func convert(object: AnyObject?, prettyPrinted: Bool) -> Data {
		let result = process(object)
		
		if !JSONSerialization.isValidJSONObject(result) {
			print("the dictionary cannot be serialized to json")
			return Data()
		}
		
		do {
			let options: JSONSerialization.WritingOptions = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
			let data = try JSONSerialization.data(withJSONObject: result, options: options)
			return data
		} catch _ {
		}

		return Data()
	}
}
