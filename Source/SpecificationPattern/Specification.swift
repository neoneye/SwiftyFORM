// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.

/// A type that can check whether or not a candidate object satisfy the rules.
///
/// Specifications are cheap to write, easy to test and can be combined to
/// represent very complex business rules.
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

public class AndSpecification: Specification {
	private let one: Specification
	private let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
	}
	
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) && other.isSatisfiedBy(candidate)
	}
}

public class OrSpecification: Specification {
	private let one: Specification
	private let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
	}
	
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) || other.isSatisfiedBy(candidate)
	}
}

public class NotSpecification: Specification {
	private let wrapped: Specification
	
	public init(_ x: Specification) {
		self.wrapped = x
	}
	
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return !wrapped.isSatisfiedBy(candidate)
	}
}

public class FalseSpecification: Specification {
	public init() {
	}
	
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return false
	}
}

public class TrueSpecification: Specification {
	public init() {
	}
	
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
