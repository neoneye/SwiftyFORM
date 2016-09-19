// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public enum ValidateResult: Equatable {
	case valid
	case hardInvalid(message: String)
	case softInvalid(message: String)
}

public func ==(lhs: ValidateResult, rhs: ValidateResult) -> Bool {
	switch lhs  {
	case .valid:
		switch rhs {
		case .valid:
			return true
		default:
			return false
		}
	case let .hardInvalid(messageA):
		switch rhs {
		case let .hardInvalid(messageB):
			return messageA == messageB
		default:
			return false
		}
	case let .softInvalid(messageA):
		switch rhs {
		case let .softInvalid(messageB):
			return messageA == messageB
		default:
			return false
		}
	}
}
