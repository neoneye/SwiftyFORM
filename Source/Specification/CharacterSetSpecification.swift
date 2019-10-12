// MIT license. Copyright (c) 2018 SwiftyFORM. All rights reserved.
import Foundation

/// Check if a string has no illegal characters.
public class CharacterSetSpecification: Specification {
	private let characterSet: CharacterSet

	public init(characterSet: CharacterSet) {
		self.characterSet = characterSet
	}

	public static func charactersInString(_ charactersInString: String) -> CharacterSetSpecification {
		let cs = CharacterSet(charactersIn: charactersInString)
		return CharacterSetSpecification(characterSet: cs)
	}

	/// Check if all characters are contained in the characterset.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate object is a string and all its characters are legal, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		guard let fullString = candidate as? String else { return false }
		for character: Character in fullString {
			let range: Range<String.Index>? =
			String(character).rangeOfCharacter(from: characterSet)
			if range == nil {
				return false // one or more characters does not satify the characterSet
			}
			if range!.isEmpty {
				return false // one or more characters does not satify the characterSet
			}
		}
		return true // the whole string satisfies the characterSet
	}
}

extension CharacterSetSpecification {
	public static var alphanumerics: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.alphanumerics)
	}
	public static var capitalizedLetters: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.capitalizedLetters)
	}
	public static var controlCharacters: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.controlCharacters)
	}
	public static var decimalDigits: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.decimalDigits)
	}
	public static var decomposables: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.decomposables)
	}
	public static var illegalCharacters: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.illegalCharacters)
	}
	public static var letters: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.letters)
	}
	public static var lowercaseLetters: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.lowercaseLetters)
	}
	public static var newlines: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.newlines)
	}
	public static var nonBaseCharacters: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.nonBaseCharacters)
	}
	public static var punctuationCharacters: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.punctuationCharacters)
	}
	public static var symbols: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.symbols)
	}
	public static var uppercaseLetters: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.uppercaseLetters)
	}
	public static var urlFragmentAllowed: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.urlFragmentAllowed)
	}
	public static var urlHostAllowed: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.urlHostAllowed)
	}
	public static var urlPasswordAllowed: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.urlPasswordAllowed)
	}
	public static var urlPathAllowed: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.urlPathAllowed)
	}
	public static var urlQueryAllowed: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.urlQueryAllowed)
	}
	public static var urlUserAllowed: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.urlUserAllowed)
	}
	public static var whitespaces: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.whitespaces)
	}
	public static var whitespacesAndNewlines: CharacterSetSpecification {
		CharacterSetSpecification(characterSet: CharacterSet.whitespacesAndNewlines)
	}
}

/// - warning:
/// These functions will be removed in the future, starting with SwiftyFORM 2.0.0
extension CharacterSetSpecification {
	public static func alphanumericCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.alphanumerics
	}

	public static func capitalizedLetterCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.capitalizedLetters
	}

	public static func controlCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.controlCharacters
	}

	public static func decimalDigitCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.decimalDigits
	}

	public static func decomposableCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.decomposables
	}

	public static func illegalCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.illegalCharacters
	}

	public static func lowercaseLetterCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.lowercaseLetters
	}

	public static func newlineCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.newlines
	}

	public static func nonBaseCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.nonBaseCharacters
	}

	public static func punctuationCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.punctuationCharacters
	}

	public static func symbolCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.symbols
	}

	public static func uppercaseLetterCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.uppercaseLetters
	}

	public static func whitespaceCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.whitespaces
	}

	public static func whitespaceAndNewlineCharacterSet() -> CharacterSetSpecification {
		CharacterSetSpecification.whitespacesAndNewlines
	}
}
