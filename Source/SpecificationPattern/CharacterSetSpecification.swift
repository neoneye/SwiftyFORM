import Foundation

public class CharacterSetSpecification: CompositeSpecification {
	public let characterSet: NSCharacterSet
	
	init(characterSet: NSCharacterSet) {
		self.characterSet = characterSet
		super.init()
	}
	
	public class func charactersInString(charactersInString: String) -> CharacterSetSpecification {
		let cs = NSCharacterSet(charactersInString: charactersInString)
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func controlCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.controlCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func whitespaceCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.whitespaceCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}

	public class func whitespaceAndNewlineCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.whitespaceAndNewlineCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func decimalDigitCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.decimalDigitCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}

	public class func lowercaseLetterCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.lowercaseLetterCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func uppercaseLetterCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.uppercaseLetterCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func nonBaseCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.nonBaseCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func alphanumericCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.alphanumericCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func decomposableCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.decomposableCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func illegalCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.illegalCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func punctuationCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.punctuationCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func capitalizedLetterCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.capitalizedLetterCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func symbolCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.symbolCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}
	
	public class func newlineCharacterSet() -> CharacterSetSpecification {
		let cs = NSCharacterSet.newlineCharacterSet()
		return CharacterSetSpecification(characterSet: cs)
	}

	
	public override func isSatisfiedBy(candidate: Any?) -> Bool {
		guard let fullString = candidate as? String else { return false }
		for character: Character in fullString.characters {
			let range: Range<String.Index>? =
			String(character).rangeOfCharacterFromSet(characterSet)
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
