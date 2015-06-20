import Foundation

public class PredicateSpecification<T>: CompositeSpecification {
	public let predicate: T -> Bool
	
	init(predicate: T -> Bool) {
		self.predicate = predicate
		super.init()
	}
	
	public override func isSatisfiedBy(candidate: Any?) -> Bool {
		guard let obj = candidate as? T else { return false }
		return predicate(obj)
	}
}
