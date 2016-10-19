// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.

/// A type that can check whether or not a candidate object satisfy the rules.
public protocol Specification {
	func isSatisfiedBy(_ candidate: Any?) -> Bool
}

extension Specification {
	public func and(_ other: Specification) -> Specification {
		return AndSpecification(self, other)
	}
	
	public func or(_ other: Specification) -> Specification {
		return OrSpecification(self, other)
	}
	
	public func not() -> Specification {
		return NotSpecification(self)
	}
}

public class AndSpecification: Specification {
	fileprivate let one: Specification
	fileprivate let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
	}
	
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) && other.isSatisfiedBy(candidate)
	}
}

public class OrSpecification: Specification {
	fileprivate let one: Specification
	fileprivate let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
	}
	
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) || other.isSatisfiedBy(candidate)
	}
}

public class NotSpecification: Specification {
	fileprivate let wrapped: Specification
	
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
