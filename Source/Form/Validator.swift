// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

public enum ValidateRule {
	case hardRule(specification: Specification, message: String)
	case softRule(specification: Specification, message: String)
	case submitRule(specification: Specification, message: String)
}

public class ValidatorBuilder {
	fileprivate var rules = [ValidateRule]()

	public init() {}

	public func hardValidate(_ specification: Specification, message: String) {
		rules.append(ValidateRule.hardRule(specification: specification, message: message))
	}

	public func softValidate(_ specification: Specification, message: String) {
		rules.append(ValidateRule.softRule(specification: specification, message: message))
	}

	public func submitValidate(_ specification: Specification, message: String) {
		rules.append(ValidateRule.submitRule(specification: specification, message: message))
	}

	public func build() -> Validator {
		return Validator(rules: self.rules)
	}
}

public class Validator {
	fileprivate let rules: [ValidateRule]

	public init(rules: [ValidateRule]) {
		self.rules = rules
	}

	public func liveValidate(_ candidate: Any?) -> ValidateResult {
		return validate(candidate, checkHardRule: true, checkSoftRule: true, checkSubmitRule: false)
	}

	public func submitValidate(_ candidate: Any?) -> ValidateResult {
		return validate(candidate, checkHardRule: true, checkSoftRule: true, checkSubmitRule: true)
	}

	public func validate(_ candidate: Any?, checkHardRule: Bool, checkSoftRule: Bool, checkSubmitRule: Bool) -> ValidateResult {
		var results = [ValidateResult]()
		for rule in rules {
			switch rule {
			case let .hardRule(specification, message):
				if checkHardRule && !specification.isSatisfiedBy(candidate) {
					return .hardInvalid(message: message)
				}
			case let .softRule(specification, message):
				if checkSoftRule && !specification.isSatisfiedBy(candidate) {
					results.append(.softInvalid(message: message))
				}
			case let .submitRule(specification, message):
				if checkSubmitRule && !specification.isSatisfiedBy(candidate) {
					return .hardInvalid(message: message)
				}
			}
		}
		if results.isEmpty {
			return .valid
		}
		return results[0]
	}
}
