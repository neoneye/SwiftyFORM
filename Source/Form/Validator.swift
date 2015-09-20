// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import Foundation

public enum ValidateRule {
	case HardRule(specification: Specification, message: String)
	case SoftRule(specification: Specification, message: String)
	case SubmitRule(specification: Specification, message: String)
}

public class ValidatorBuilder {
	private var rules = [ValidateRule]()
	
	public init() {}
	
	public func hardValidate(specification: Specification, message: String) {
		rules.append(ValidateRule.HardRule(specification: specification, message: message))
	}
	
	public func softValidate(specification: Specification, message: String) {
		rules.append(ValidateRule.SoftRule(specification: specification, message: message))
	}
	
	public func submitValidate(specification: Specification, message: String) {
		rules.append(ValidateRule.SubmitRule(specification: specification, message: message))
	}
	
	public func build() -> Validator {
		return Validator(rules: self.rules)
	}
}

public class Validator {
	private let rules: [ValidateRule]
	
	public init(rules: [ValidateRule]) {
		self.rules = rules
	}
	
	public func liveValidate(candidate: Any?) -> ValidateResult {
		return validate(candidate, checkHardRule: true, checkSoftRule: true, checkSubmitRule: false)
	}
	
	public func submitValidate(candidate: Any?) -> ValidateResult {
		return validate(candidate, checkHardRule: true, checkSoftRule: true, checkSubmitRule: true)
	}
	
	public func validate(candidate: Any?, checkHardRule: Bool, checkSoftRule: Bool, checkSubmitRule: Bool) -> ValidateResult {
		var results = [ValidateResult]()
		for rule in rules {
			switch rule {
			case let .HardRule(specification, message):
				if checkHardRule && !specification.isSatisfiedBy(candidate) {
					return .HardInvalid(message: message)
				}
			case let .SoftRule(specification, message):
				if checkSoftRule && !specification.isSatisfiedBy(candidate) {
					results.append(.SoftInvalid(message: message))
				}
			case let .SubmitRule(specification, message):
				if checkSubmitRule && !specification.isSatisfiedBy(candidate) {
					return .HardInvalid(message: message)
				}
			}
		}
		if results.isEmpty {
			return .Valid
		}
		return results[0]
	}
}

