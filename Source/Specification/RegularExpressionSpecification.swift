// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

/// Check if a string satisfies a regular expression (AKA. regex).
///
/// [Regex tutorial](http://www.regular-expressions.info/quickstart.html)
///
/// Regex are really powerful for validating textfields. Here a business rule could be
/// that the text must be like this: `aabbcc8`. A regex for this:
///
/// `let spec = RegularExpressionSpecification(pattern: "^a+b+c+\\d$")`
public class RegularExpressionSpecification: Specification {
	private let regularExpression: NSRegularExpression

	public init(regularExpression: NSRegularExpression) {
		self.regularExpression = regularExpression
	}

	public convenience init(pattern: String) {
		let regularExpression = try! NSRegularExpression(pattern: pattern, options: [])
		self.init(regularExpression: regularExpression)
	}

	/// Check if the regex is satisfied.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate object is a `String` and it satisfies the regex, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		guard let s = candidate as? String else { return false }
		return regularExpression.numberOfMatches(in: s, options: [], range: NSMakeRange(0, s.characters.count)) > 0
	}
}
