// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

public class DumpVisitor: FormItemVisitor {
	private typealias StringToAny = [String: Any?]

	public init() {
	}

	class func dump(_ prettyPrinted: Bool = true, items: [FormItem]) -> Data {
		var result = [StringToAny]()
		var rowNumber: Int = 0
		for item in items {
			let dumpVisitor = DumpVisitor()
			item.accept(visitor: dumpVisitor)

			var dict = StringToAny()
			dict["row"] = rowNumber

			let validateVisitor = ValidateVisitor()
			item.accept(visitor: validateVisitor)
			switch validateVisitor.result {
			case .valid:
				dict["validate-status"] = "ok"
			case .hardInvalid(let message):
				dict["validate-status"] = "hard-invalid"
				dict["validate-message"] = message
			case .softInvalid(let message):
				dict["validate-status"] = "soft-invalid"
				dict["validate-message"] = message
			}

			dict.update(dumpVisitor.dict)

			result.append(dict)
			rowNumber += 1
		}

		return JSONHelper.convert(result, prettyPrinted: prettyPrinted)
	}

	private var dict = StringToAny()

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

	public func visit(object: DatePickerFormItem) {
		dict["class"] = "DatePickerFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["date"] = object.value
		dict["datePickerMode"] = object.datePickerMode.description
		dict["locale"] = object.locale
		dict["minimumDate"] = object.minimumDate
		dict["maximumDate"] = object.maximumDate
		dict["minuteInterval"] = object.minuteInterval
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

	public func visit(object: PickerViewFormItem) {
		dict["class"] = "PickerViewFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}
}

internal struct JSONHelper {

	/// Convert from a complex object to a simpler json object.
	///
	/// This function is recursive.
	///
	/// - parameter objectOrNil: The complex object to be converted.
	///
	/// - returns: a converted object otherwise NSNull.
	static func process(_ objectOrNil: Any?) -> Any {
		guard let object = objectOrNil else {
			return NSNull()
		}
		if object is NSNull {
			return NSNull()
		}
		if let dict = object as? NSDictionary {
			var result = [String: Any]()
			for (keyObject, valueObject) in dict {
				guard let key = keyObject as? String else {
					print("Expected string for key, skipping key: \(keyObject)")
					continue
				}
				result[key] = process(valueObject)
			}
			return result
		}
		if let array = object as? NSArray {
			var result = [Any]()
			for valueObject in array {
				let item = process(valueObject)
				result.append(item)
			}
			return result
		}
		if let item = object as? String {
			return item
		}
		if let item = object as? Bool {
			return item
		}
		if let item = object as? Int {
			return item
		}
		if let item = object as? UInt {
			return item
		}
		if let item = object as? Float {
			return item
		}
		if let item = object as? Double {
			return item
		}
		if let item = object as? NSNumber {
			return item
		}
		if let item = object as? Date {
			return item.description
		}

		print("skipping unknown item: \(object)  \(object.self)")
		return NSNull()
	}

	/// Convert from a complex object to json data.
	///
	/// - parameter unprocessedObject: The complex object to be converted.
	/// - parameter prettyPrinted: If true then the json is formatted so it's human readable.
	///
	/// - returns: Data object containing json.
	static func convert(_ unprocessedObject: Any?, prettyPrinted: Bool) -> Data {
		let object = process(unprocessedObject)

		if !JSONSerialization.isValidJSONObject(object) {
			print("the dictionary cannot be serialized to json")
			return Data()
		}

		do {
			let options: JSONSerialization.WritingOptions = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
			let data = try JSONSerialization.data(withJSONObject: object, options: options)
			return data
		} catch _ {
		}

		return Data()
	}
}
