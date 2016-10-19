import Foundation

public class PredicateSpecification<T>: Specification {
	public let predicate: (T) -> Bool
	
	init(predicate: @escaping (T) -> Bool) {
		self.predicate = predicate
	}
	
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		guard let obj = candidate as? T else { return false }
		return predicate(obj)
	}
}
