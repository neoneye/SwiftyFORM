// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

public enum ValidateResult: Equatable {
	case valid
	case hardInvalid(message: String)
	case softInvalid(message: String)
}

public func ==(lhs: ValidateResult, rhs: ValidateResult) -> Bool {
	switch (lhs, rhs) {
	case (.valid, .valid):
		return true
	case let (.hardInvalid(messageA), .hardInvalid(messageB)):
		return messageA == messageB
	case let (.softInvalid(messageA), .softInvalid(messageB)):
		return messageA == messageB
	default:
		return false
	}
}
