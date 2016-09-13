import Foundation

open class CharacterSetSpecification: CompositeSpecification {
	open let characterSet: CharacterSet
	
	init(characterSet: CharacterSet) {
		self.characterSet = characterSet
		super.init()
	}
	
	open class func charactersInString(_ charactersInString: String) -> CharacterSetSpecification {
		let cs = CharacterSet(charactersIn: charactersInString)
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func controlCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.controlCharacters
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func whitespaceCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.whitespaces
		return CharacterSetSpecification(characterSet: cs)
	}

	open class func whitespaceAndNewlineCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.whitespacesAndNewlines
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func decimalDigitCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.decimalDigits
		return CharacterSetSpecification(characterSet: cs)
	}

	open class func lowercaseLetterCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.lowercaseLetters
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func uppercaseLetterCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.uppercaseLetters
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func nonBaseCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.nonBaseCharacters
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func alphanumericCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.alphanumerics
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func decomposableCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.decomposables
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func illegalCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.illegalCharacters
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func punctuationCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.punctuationCharacters
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func capitalizedLetterCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.capitalizedLetters
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func symbolCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.symbols
		return CharacterSetSpecification(characterSet: cs)
	}
	
	open class func newlineCharacterSet() -> CharacterSetSpecification {
		let cs = CharacterSet.newlines
		return CharacterSetSpecification(characterSet: cs)
	}

	
	open override func isSatisfiedBy(_ candidate: Any?) -> Bool {
		guard let fullString = candidate as? String else { return false }
		for character: Character in fullString.characters {
			let range: Range<String.Index>? =
			String(character).rangeOfCharacter(from: characterSet)
			if range == nil {
				return false // one or more characters does not satify the characterSet
			}
			if range!.isEmpty {
				return false // one or more characters does not satify the characterSet
			}
		}
		return true // the whole string satisfies our characterSet
	}
	
}
