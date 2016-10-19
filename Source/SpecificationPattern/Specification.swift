// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.

/// A type that can check whether or not a candidate object satisfy the rules.
public protocol Specification {
	func isSatisfiedBy(_ candidate: Any?) -> Bool
	func and(_ other: Specification) -> Specification
	func or(_ other: Specification) -> Specification
	func not() -> Specification
}

open class CompositeSpecification: Specification {
	open func isSatisfiedBy(_ candidate: Any?) -> Bool {
		// subclass must implement this method
		return false
	}
	
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

public class AndSpecification: CompositeSpecification {
	fileprivate let one: Specification
	fileprivate let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
		super.init()
	}
	
	override public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) && other.isSatisfiedBy(candidate)
	}
}

public class OrSpecification: CompositeSpecification {
	fileprivate let one: Specification
	fileprivate let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
		super.init()
	}
	
	override public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) || other.isSatisfiedBy(candidate)
	}
}

public class NotSpecification: CompositeSpecification {
	fileprivate let wrapped: Specification
	
	public init(_ x: Specification) {
		self.wrapped = x
		super.init()
	}
	
	override public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return !wrapped.isSatisfiedBy(candidate)
	}
}

public class FalseSpecification: CompositeSpecification {
	override public init() {
		super.init()
	}
	
	override public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return false
	}
}

public class TrueSpecification: CompositeSpecification {
	override public init() {
		super.init()
	}
	
	override public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return true
	}
}
