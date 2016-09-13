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
	
	open func and(_ other: Specification) -> Specification {
		return AndSpecification(self, other)
	}
	
	open func or(_ other: Specification) -> Specification {
		return OrSpecification(self, other)
	}
	
	open func not() -> Specification {
		return NotSpecification(self)
	}
}

open class AndSpecification: CompositeSpecification {
	fileprivate let one: Specification
	fileprivate let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
		super.init()
	}
	
	override open func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) && other.isSatisfiedBy(candidate)
	}
}

open class OrSpecification: CompositeSpecification {
	fileprivate let one: Specification
	fileprivate let other: Specification
	
	public init(_ x: Specification, _ y: Specification)  {
		self.one = x
		self.other = y
		super.init()
	}
	
	override open func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return one.isSatisfiedBy(candidate) || other.isSatisfiedBy(candidate)
	}
}

open class NotSpecification: CompositeSpecification {
	fileprivate let wrapped: Specification
	
	public init(_ x: Specification) {
		self.wrapped = x
		super.init()
	}
	
	override open func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return !wrapped.isSatisfiedBy(candidate)
	}
}

open class FalseSpecification: CompositeSpecification {
	override public init() {
		super.init()
	}
	
	override open func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return false
	}
}

open class TrueSpecification: CompositeSpecification {
	override public init() {
		super.init()
	}
	
	override open func isSatisfiedBy(_ candidate: Any?) -> Bool {
		return true
	}
}
