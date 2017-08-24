// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.

/// A type that can check whether or not a candidate object satisfy the rules.
///
/// Specifications are cheap to write, easy to test and can be combined to
/// represent very complex business rules.
///
/// More about specification pattern on [Wikipedia](https://en.wikipedia.org/wiki/Specification_pattern).
public protocol Specification {

	/// The central part of a specification is the `isSatisfiedBy()` function, 
	/// which is used to check if an object satisfies the specification.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate satisfies the specification, `false` otherwise.
	func isSatisfiedBy(_ candidate: Any?) -> Bool

}

extension Specification {

	/// Combine two specifications into one.
	///
	/// This is an **AND** operation. The new specification is satisfied
	/// when both specifications are satisfied.
	///
	/// - parameter other: The other specification that is to be to combine with this specification.
	///
	/// - returns: A combined specification
	public func and(_ other: Specification) -> Specification {
		return AndSpecification(self, other)
	}

	/// Combine two specifications into one.
	///
	/// This is an **OR** operation. The new specification is satisfied
	/// when either of the specifications are satisfied.
	///
	/// - parameter other: The other specification that is to be to combine with this specification.
	///
	/// - returns: A combined specification
	public func or(_ other: Specification) -> Specification {
		return OrSpecification(self, other)
	}

	/// Invert a specification.
	///
	/// This is a **NOT** operation. The new specification is satisfied
	/// when the specification is not satisfied.
	///
	/// - returns: An inverted specification
	public func not() -> Specification {
		return NotSpecification(self)
	}
}

/// Check if two specifications are both satisfied.
///
/// This is a composite specification that combines two specifications 
/// into a single specification.
public class AndSpecification: Specification {
	private let one: Specification
	private let other: Specification

	public init(_ x: Specification, _ y: Specification) {
		self.one = x
		self.other = y
	}

	/// Check if both specifications are satisfied.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate satisfies both specifications, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) && other.isSatisfiedBy(candidate)
	}
}

/// Check if either of the specifications are satisfied.
///
/// This is a composite specification that combines two specifications
/// into a single specification.
public class OrSpecification: Specification {
	private let one: Specification
	private let other: Specification

	public init(_ x: Specification, _ y: Specification) {
		self.one = x
		self.other = y
	}

	/// Check if either of the specifications are satisfied.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate satisfies either of the specifications, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) || other.isSatisfiedBy(candidate)
	}
}

/// Check if a specification is not satisfied.
///
/// This is a composite specification that wraps another specification.
public class NotSpecification: Specification {
	private let wrapped: Specification

	public init(_ x: Specification) {
		self.wrapped = x
	}

	/// Check if specification is not satisfied.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate doesn't satisfy the specification, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return !wrapped.isSatisfiedBy(candidate)
	}
}

/// This specification is never satisfied.
public class FalseSpecification: Specification {
	public init() {
	}

	/// Doesn't do anything. This specification is never satisfied.
	///
	/// - parameter candidate: The parameter is ignored.
	///
	/// - returns: `false` always.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return false
	}
}

/// This specification is always satisfied.
public class TrueSpecification: Specification {
	public init() {
	}

	/// Doesn't do anything. This specification is always satisfied.
	///
	/// - parameter candidate: The parameter is ignored.
	///
	/// - returns: `true` always.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return true
	}
}

/// - warning:
/// This class will be removed in the future, starting with SwiftyFORM 2.0.0
open class CompositeSpecification: Specification {
	open func isSatisfiedBy(_ candidate: Any?) -> Bool {
		// subclass must implement this function
		return false
	}
}
