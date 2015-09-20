// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import Foundation

public enum ValidateResult: Equatable {
	case Valid
	case HardInvalid(message: String)
	case SoftInvalid(message: String)
}

public func ==(lhs: ValidateResult, rhs: ValidateResult) -> Bool {
	switch lhs  {
	case .Valid:
		switch rhs {
		case .Valid:
			return true
		default:
			return false
		}
	case let .HardInvalid(messageA):
		switch rhs {
		case let .HardInvalid(messageB):
			return messageA == messageB
		default:
			return false
		}
	case let .SoftInvalid(messageA):
		switch rhs {
		case let .SoftInvalid(messageB):
			return messageA == messageB
		default:
			return false
		}
	}
}
