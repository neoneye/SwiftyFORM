// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

/// Partial validation of email using regex
///
/// Email addresses are often requested as input to website as user identification
/// for the purpose of data validation. An email address is generally recognized as 
/// having two parts joined with an at-sign (@). However, the technical specification 
/// detailed in RFC 822 and subsequent RFCs are more extensive, offering complex and 
/// strict restrictions. It is impossible to match these restrictions with a single 
/// technique. Using regular expressions results in long patterns giving incomplete results.
///
/// More info about these problems on [Wikipedia](http://en.wikipedia.org/wiki/Email_address).
public class EmailSpecification: Specification {
	private let specification: RegularExpressionSpecification

	public init() {
		self.specification = RegularExpressionSpecification(pattern: emailRegularExpression)
	}

	/// Check if a string could be an email address.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate object is a string and could be an email, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return specification.isSatisfiedBy(candidate)
	}

	/// [RFC5322](http://tools.ietf.org/html/rfc5322#section-3.4) address specification
	///
	/// Taken from [Stackoverflow](http://stackoverflow.com/a/1149894/78336)
	private let emailRegularExpression =
		"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
		"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
		"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
		"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
		"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
		"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
		"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
}
