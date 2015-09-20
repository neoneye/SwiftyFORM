// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import Foundation

public class TextFieldFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitTextField(self)
	}
	
	public var keyboardType: UIKeyboardType = .Default
	public func keyboardType(keyboardType: UIKeyboardType) -> Self {
		self.keyboardType = keyboardType
		return self
	}
	
	
	public var autocorrectionType: UITextAutocorrectionType = .No
	public var autocapitalizationType: UITextAutocapitalizationType = .None
	public var spellCheckingType: UITextSpellCheckingType = .No
	public var secureTextEntry = false
	
	public var returnKeyType: UIReturnKeyType = .Default
	public func returnKeyType(returnKeyType: UIReturnKeyType) -> Self {
		self.returnKeyType = returnKeyType
		return self
	}
	
	
	typealias SyncBlock = (value: String) -> Void
	var syncCellWithValue: SyncBlock = { (string: String) in
		DLog("sync is not overridden")
	}
	
	internal var innerValue: String = ""
	public var value: String {
		get {
			return self.innerValue
		}
		set {
			self.assignValueAndSync(newValue)
		}
	}
	
	typealias TextDidChangeBlock = (value: String) -> Void
	var textDidChangeBlock: TextDidChangeBlock = { (value: String) in
		DLog("not overridden")
	}
	
	public func textDidChange(value: String) {
		innerValue = value
		textDidChangeBlock(value: value)
	}

	func assignValueAndSync(value: String) {
		innerValue = value
		syncCellWithValue(value: value)
	}
	
	var reloadPersistentValidationState: Void -> Void = {}
	
	
	var obtainTitleWidth: Void -> CGFloat = {
		return 0
	}
	
	var assignTitleWidth: CGFloat -> Void = { (width: CGFloat) in
		// do nothing
	}
	
	
	public var placeholder: String = ""
	public func placeholder(placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	public func password() -> Self {
		self.secureTextEntry = true
		return self
	}
	
	let validatorBuilder = ValidatorBuilder()
	
	public func validate(specification: Specification, message: String) -> Self {
		validatorBuilder.hardValidate(specification, message: message)
		return self
	}
	
	public func softValidate(specification: Specification, message: String) -> Self {
		validatorBuilder.softValidate(specification, message: message)
		return self
	}
	
	public func submitValidate(specification: Specification, message: String) -> Self {
		validatorBuilder.submitValidate(specification, message: message)
		return self
	}
	
	public func required(message: String) -> Self {
		submitValidate(CountSpecification.min(1), message: message)
		return self
	}
	
	public func liveValidateValueText() -> ValidateResult {
		return  validatorBuilder.build().liveValidate(self.value)
	}
	
	public func liveValidateText(text: String) -> ValidateResult {
		return validatorBuilder.build().validate(text, checkHardRule: true, checkSoftRule: true, checkSubmitRule: false)
	}
	
	public func submitValidateValueText() -> ValidateResult {
		return validatorBuilder.build().submitValidate(self.value)
	}
	
	public func submitValidateText(text: String) -> ValidateResult {
		return validatorBuilder.build().validate(text, checkHardRule: true, checkSoftRule: true, checkSubmitRule: true)
	}
	
	public func validateText(text: String, checkHardRule: Bool, checkSoftRule: Bool, checkSubmitRule: Bool) -> ValidateResult {
		return validatorBuilder.build().validate(text, checkHardRule: checkHardRule, checkSoftRule: checkSoftRule, checkSubmitRule: checkSubmitRule)
	}
}
