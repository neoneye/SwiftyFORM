// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

/// Check if a collection (String/Array) has the right number of elements.
public class CountSpecification: Specification {

	/// Create a specification that checks for a minimum count
	///
	/// - parameter count: The minimum number of elements required
	///
	/// - returns: A CountSpecification that checks for a minimum count
	public static func min(_ count: Int) -> CountSpecification {
		return CountSpecification().min(count)
	}

	/// Create a specification that checks for a maximum count
	///
	/// - parameter count: The maximum number of elements required
	///
	/// - returns: A CountSpecification that checks for a maximum count
	public static func max(_ count: Int) -> CountSpecification {
		return CountSpecification().max(count)
	}

	/// Create a specification that checks if count is inside a range
	///
	/// - parameter minCount: The minimum number of elements required
	/// - parameter maxCount: The maximum number of elements required
	///
	/// - returns: A CountSpecification that checks if count is inside range
	public static func between(_ minCount: Int, _ maxCount: Int) -> CountSpecification {
		return CountSpecification().min(minCount).max(maxCount)
	}

	/// Create a specification that checks if count is exactly X elements
	///
	/// - parameter count: The exact number of elements required
	///
	/// - returns: A CountSpecification that checks if count is exactly the required count
	public static func exactly(_ count: Int) -> CountSpecification {
		return CountSpecification().min(count).max(count)
	}

	private var minCount: Int?
	private var maxCount: Int?

	private func min(_ count: Int) -> CountSpecification {
		minCount = count
		return self
	}

	private func max(_ count: Int) -> CountSpecification {
		maxCount = count
		return self
	}

	/// Check if the number of elements is between min and max.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate object has a count between min and max, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
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
