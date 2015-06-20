public protocol Specification {
	func isSatisfiedBy(candidate: Any?) -> Bool
	func and(other: Specification) -> Specification
	func or(other: Specification) -> Specification
	func not() -> Specification
}

public class CompositeSpecification: Specification {
	public func isSatisfiedBy(candidate: Any?) -> Bool {
		// subclass must implement this method
		return false
	}
	
	public func and(other: Specification) -> Specification {
		return AndSpecification(self, other)
	}
	
	public func or(other: Specification) -> Specification {
		return OrSpecification(self, other)
	}
	
	public func not() -> Specification {
		return NotSpecification(self)
	}
}

public class AndSpecification: CompositeSpecification {
	private let one: Specification
	private let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
		super.init()
	}
	
	override public func isSatisfiedBy(candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) && other.isSatisfiedBy(candidate)
	}
}

public class OrSpecification: CompositeSpecification {
	private let one: Specification
	private let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
		super.init()
	}
	
	override public func isSatisfiedBy(candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) || other.isSatisfiedBy(candidate)
	}
}

public class NotSpecification: CompositeSpecification {
	private let wrapped: Specification
	
	public init(_ x: Specification) {
		self.wrapped = x
		super.init()
	}
	
	override public func isSatisfiedBy(candidate: Any?) -> Bool {
		return !wrapped.isSatisfiedBy(candidate)
	}
}

public class FalseSpecification: CompositeSpecification {
	override public init() {
		super.init()
	}
	
	override public func isSatisfiedBy(candidate: Any?) -> Bool {
		return false
	}
}

public class TrueSpecification: CompositeSpecification {
	override public init() {
		super.init()
	}
	
	override public func isSatisfiedBy(candidate: Any?) -> Bool {
		return true
	}
}
