import Foundation

public class CountSpecification: CompositeSpecification {
	
	public class func min(_ count: Int) -> CountSpecification {
		return CountSpecification().min(count)
	}
	
	public class func max(_ count: Int) -> CountSpecification {
		return CountSpecification().max(count)
	}
	
	public class func between(_ minCount: Int, _ maxCount: Int) -> CountSpecification {
		return CountSpecification().min(minCount).max(maxCount)
	}
	
	public class func exactly(_ count: Int) -> CountSpecification {
		return CountSpecification().min(count).max(count)
	}
	
	public var minCount: Int?
	public var maxCount: Int?
	
	public func min(_ count: Int) -> CountSpecification {
		minCount = count
		return self
	}
	
	public func max(_ count: Int) -> CountSpecification {
		maxCount = count
		return self
	}
	
	public override func isSatisfiedBy(_ candidate: Any?) -> Bool {
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
		case (.some(let min), .some(let max)):
			return (n >= min) && (n <= max)
		case (.some(let min), _):
			return (n >= min)
		case (_, .some(let max)):
			return (n <= max)
		default:
			break
		}
		
		return false
	}
}
