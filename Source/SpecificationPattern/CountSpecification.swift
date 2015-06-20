import Foundation

public class CountSpecification: CompositeSpecification {
	
	public class func min(count: Int) -> CountSpecification {
		return CountSpecification().min(count)
	}
	
	public class func max(count: Int) -> CountSpecification {
		return CountSpecification().max(count)
	}
	
	public class func between(minCount: Int, _ maxCount: Int) -> CountSpecification {
		return CountSpecification().min(minCount).max(maxCount)
	}
	
	public class func exactly(count: Int) -> CountSpecification {
		return CountSpecification().min(count).max(count)
	}
	
	public var minCount: Int?
	public var maxCount: Int?
	
	public func min(count: Int) -> CountSpecification {
		minCount = count
		return self
	}
	
	public func max(count: Int) -> CountSpecification {
		maxCount = count
		return self
	}
	
	public override func isSatisfiedBy(candidate: Any?) -> Bool {
		if candidate == nil {
			return false
		}

		var n: Int = 0
		repeat {
			if let x = candidate as? String {
				n = x.characters.count
				break
			}
			
			// Obtain length of Array, see http://stackoverflow.com/a/25901509/78336
			if let y = candidate as? NSArray {
				n = (y as Array).count
				break
			}
			
			// This candidate is not a collection
			return false
		} while(false)
		
		
		switch (minCount, maxCount) {
		case (.Some(let min), .Some(let max)):
			return (n >= min) && (n <= max)
		case (.Some(let min), _):
			return (n >= min)
		case (_, .Some(let max)):
			return (n <= max)
		default:
			break
		}
		
		return false
	}
}
