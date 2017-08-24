// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.

/// AND operator
///
/// Combine two specifications into a single specification.
///
/// This is a shorthand for the `Specification.and()` function.
///
/// Both the `left` specifiction and the `right` specifiction must be satisfied.
///
/// ## Example
///
/// `let spec = onlyDigits & between2And4Letters & modulus13Checksum`
///
///
/// - parameter left: The specification to be checked first.
/// - parameter right: The specification to be checked last.
///
/// - returns: A combined specification
public func & (left: Specification, right: Specification) -> Specification {
	return left.and(right)
}

/// OR operator
///
/// Combine two specifications into a single specification.
///
/// This is a shorthand for the `Specification.or()` function.
///
/// Either the `left` specifiction or the `right` specifiction must be satisfied.
///
/// ## Example
///
/// `let spec = connectionTypeWifi | connectionType4G | hasOfflineData`
///
///
/// - parameter left: The specification to be checked first.
/// - parameter right: The specification to be checked last.
///
/// - returns: A combined specification
public func | (left: Specification, right: Specification) -> Specification {
	return left.or(right)
}

/// Negate operator
///
/// This is a shorthand for the `Specification.not()` function.
///
/// This specifiction is satisfied, when the given specification is not satisfied.
///
/// This specifiction is not satisfied, when the given specification is satisfied.
///
/// ## Example
///
/// `let spec = ! filesystemIsFull`
///
///
/// - parameter specification: The specification to be inverted.
///
/// - returns: A specification
public prefix func ! (specification: Specification) -> Specification {
	return specification.not()
}

/// Equivalence operator 
///
/// This is a shorthand for the `Specification.isSatisfiedBy()` function
///
/// ## Example:
///
/// `let spec = CharacterSetSpecification.decimalDigits`
/// `spec == "123"`
///
///
/// - parameter left: The specification that is to perform the checking
/// - parameter right: The candidate object that is to be checked.
///
/// - returns: `true` if the candidate object satisfies the specification, `false` otherwise.
public func == (left: Specification, right: Any?) -> Bool {
	return left.isSatisfiedBy(right)
}

/// Not equivalent operator
///
/// This is a shorthand for the `Specification.isSatisfiedBy()` function
///
/// ## Example:
///
/// `let spec = CharacterSetSpecification.decimalDigits`
/// `spec != "123"`
///
///
/// - parameter left: The specification that is to perform the checking
/// - parameter right: The candidate object that is to be checked.
///
/// - returns: `true` if the candidate object doesn't satisfy the specification, `false` otherwise.
public func != (left: Specification, right: Any?) -> Bool {
	return !left.isSatisfiedBy(right)
}
