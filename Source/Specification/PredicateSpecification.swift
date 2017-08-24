// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

/// Check if an object is satisfied by a closure.
///
/// Closure is sometimes preferred instead of subclassing the `Specification` protocol.
public class PredicateSpecification<T>: Specification {
	private let predicate: (T) -> Bool

	public init(predicate: @escaping (T) -> Bool) {
		self.predicate = predicate
	}

	/// Check if the closure is satisfied.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate object is of the right type and is satisfied by the closure, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		guard let obj = candidate as? T else { return false }
		return predicate(obj)
	}
}
