import Foundation

public class PredicateSpecification<T>: CompositeSpecification {
	public let predicate: (T) -> Bool
	
	init(predicate: @escaping (T) -> Bool) {
		self.predicate = predicate
		super.init()
	}
	
	public override func isSatisfiedBy(_ candidate: Any?) -> Bool {
		guard let obj = candidate as? T else { return false }
		return predicate(obj)
	}
}
