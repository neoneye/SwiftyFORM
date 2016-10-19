// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.

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
public func != (left: Specification, right: Any?) -> Bool {
	return !left.isSatisfiedBy(right)
}
