// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

class PrecisionSlider_InnerModel: CustomDebugStringConvertible {
	var minimumValue: Double = 0.0
	var maximumValue: Double = 100.0
	
	var originalMaximumValue: Double = 0.0
	var originalMinimumValue: Double = 100.0
	
	enum ZoomMode {
		case None
		case ZoomIn(count: UInt)
		case ZoomOut(count: UInt)
		
		var scalar: Double {
			switch self {
			case .None:
				return 1
			case let .ZoomIn(count):
				return Double(count)
			case let .ZoomOut(count):
				return 1 / Double(count)
			}
		}
	}
	
	var zoomMode = ZoomMode.None
	
	func reloadZoomMode() {
		if scale > 25000 {
			zoomMode = .ZoomIn(count: 1000)
			return
		}
		if scale > 9000 {
			zoomMode = .ZoomIn(count: 200)
			return
		}
		if scale > 2500 {
			zoomMode = .ZoomIn(count: 100)
			return
		}
		if scale > 800 {
			zoomMode = .ZoomIn(count: 20)
			return
		}
		if scale > 250 {
			zoomMode = .ZoomIn(count: 10)
			return
		}
		if scale > 100 {
			zoomMode = .ZoomIn(count: 2)
			return
		}
		if scale > 30 {
			zoomMode = .None
			return
		}
		if scale > 10 {
			zoomMode = .ZoomOut(count: 5)
			return
		}
		if scale > 3 {
			zoomMode = .ZoomOut(count: 10)
			return
		}
		if scale > 0.6 {
			zoomMode = .ZoomOut(count: 50)
			return
		}
		if scale > 0.3 {
			zoomMode = .ZoomOut(count: 100)
			return
		}
		if scale > 0.15 {
			zoomMode = .ZoomOut(count: 500)
			return
		}
		if scale > 0.032 {
			zoomMode = .ZoomOut(count: 1000)
			return
		}
		if scale > 0.004 {
			zoomMode = .ZoomOut(count: 5000)
			return
		}
		if scale > 0.0025 {
			zoomMode = .ZoomOut(count: 10000)
			return
		}
		if scale > 0.0004 {
			zoomMode = .ZoomOut(count: 50000)
			return
		}

		zoomMode = .ZoomOut(count: 100000)
	}
	
	func updateRange() {
		reloadZoomMode()
		//print("zoomMode: \(zoomMode)  scale: \(scale)")
		
		maximumValue = originalMaximumValue * zoomMode.scalar
		minimumValue = originalMinimumValue * zoomMode.scalar
		
		var count = Int(floor(maximumValue) - ceil(minimumValue)) + 1
		
		let sizeBefore = ceil(minimumValue) - minimumValue
		//print("size before: \(sizeBefore)    \(minimumValue)")
		if sizeBefore > 0.0000001 {
			//print("partial item before. size: \(sizeBefore)   minimumValue: \(minimumValue)")
			hasPartialItemBefore = true
			sizeOfPartialItemBefore = sizeBefore
			count -= 1
		} else {
			hasPartialItemBefore = false
			sizeOfPartialItemBefore = 0
		}
		
		let sizeAfter = maximumValue - floor(maximumValue)
		//print("size after: \(sizeAfter)    \(maximumValue)")
		if sizeAfter > 0.0000001 {
			//print("partial item after. size: \(sizeAfter)   minimumValue: \(maximumValue)")
			hasPartialItemAfter = true
			sizeOfPartialItemAfter = sizeAfter
			count -= 1
		} else {
			hasPartialItemAfter = false
			sizeOfPartialItemAfter = 0
		}
		
		// prevent negative number of items
		if count < 0 {
			// In this case use the "single_cell"
			//			print("maximumValue=\(maximumValue)  minimumValue=\(minimumValue)")
			numberOfFullItems = 0
			hasOnePartialItem = true
			sizeOfOnePartialItem = maximumValue - minimumValue
			hasPartialItemBefore = false
			sizeOfPartialItemBefore = 0
			hasPartialItemAfter = false
			sizeOfPartialItemAfter = 0
		} else {
			numberOfFullItems = count
			hasOnePartialItem = false
		}
		
		//		print("model: \(self)")
	}
	
	/*
	This is used when the range is tiny and doesn't cross any integer boundary.
	Example of such a range: from min=0.4 to max=0.6
	here the size of the range is 0.2, which is (max - min)
	*/
	var hasOnePartialItem = false
	var sizeOfOnePartialItem: Double = 0.0
	
	/*
	This is used when the range-start crosses an integer boundary.
	Example of such a range: from min=0.7 to max=3.3
	In this case there will be a partial-item-before
	with the range from min=0.7 to max=1.0
	here the size of the range is 0.3  (max - min)
	*/
	var hasPartialItemBefore = false
	var sizeOfPartialItemBefore: Double = 0.0
	
	/*
	This is used when the range is crossing zero or more integer boundaries.
	Example of such a range: from min=0.7 to max=3.3
	In this case there will be a full items will span from min=1.0 to max=3.0
	here the number of full items is 2  (max - min)
	The size of a full item is alway 1, since it's full.
	*/
	var numberOfFullItems = 100
	
	/*
	This is used when the range-end crosses an integer boundary.
	Example of such a range: from min=0.7 to max=3.3
	In this case there will be a partial-item-after
	with the range from min=3.0 to max=3.3
	here the size of the range is 0.3  (max - min)
	*/
	var hasPartialItemAfter = false
	var sizeOfPartialItemAfter: Double = 0.0
	
	var scale: Double = 60.0
	
	var lengthOfFullItem: Double {
		let result = ceil(scale / zoomMode.scalar)
		if result < 0.1 {
			return 0.1
		}
		return result
	}
	
	var lengthOfAllFullItems: Double {
		return Double(numberOfFullItems) * lengthOfFullItem
	}
	var lengthOfOnePartialItem: Double {
		return ceil(lengthOfFullItem * sizeOfOnePartialItem)
	}
	var lengthOfPartialItemBefore: Double {
		return ceil(lengthOfFullItem * sizeOfPartialItemBefore)
	}
	var remainingLengthOfPartialItemBefore: Double {
		return ceil(lengthOfFullItem * (1.0 - sizeOfPartialItemBefore))
	}
	var lengthOfPartialItemAfter: Double {
		return ceil(lengthOfFullItem * sizeOfPartialItemAfter)
	}
	var remainingLengthOfPartialItemAfter: Double {
		return ceil(lengthOfFullItem * (1.0 - sizeOfPartialItemAfter))
	}
	
	var lengthOfContent: Double {
		if hasOnePartialItem {
			return lengthOfOnePartialItem
		}
		var length: Double = 0
		if hasPartialItemBefore {
			length += lengthOfFullItem * 2
		}
		length += lengthOfAllFullItems
		if hasPartialItemAfter {
			length += lengthOfFullItem * 2
		}
		return length
	}
	
	static let height: CGFloat = 130
	
	func modulo10String(index: Int) -> String {
		let displayValue = index % 10
		return String(displayValue)
	}
	
	func labelTextForIndexPath(indexPath: NSIndexPath) -> String? {
		var index = Int(floor(minimumValue)) + indexPath.row
		if hasPartialItemBefore {
			index += 1
		}

		switch zoomMode {
		case .None:
			let displayValue = index % 10
			return String(displayValue)
		case let .ZoomIn(count):
			if count == 2 {
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			}
			if count == 10 {
				if index % 10 != 0 {
					return nil
				}
				return modulo10String(index / 10)
			}
			if count == 20 {
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			}
			if count == 100 {
				if index % 10 != 0 {
					return nil
				}
				return modulo10String(index / 10)
			}
			if count == 200 {
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			}
			if count == 1000 {
				if index % 10 != 0 {
					return nil
				}
				return modulo10String(index / 10)
			}
		case let .ZoomOut(count):
			if count == 5 {
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			}
			if count == 10 {
				return modulo10String(index)
			}
			if count == 50 {
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			}
			if count == 100 {
				return modulo10String(index)
			}
			if count == 500 {
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			}
			if count == 1000 {
				return modulo10String(index)
			}
			if count == 5000 {
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			}
			if count == 10000 {
				return modulo10String(index)
			}
			if count == 50000 {
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			}
			if count == 100000 {
				return modulo10String(index)
			}
			return nil
		}
		return nil
	}
	
	let markMajorColor = UIColor.blackColor()
	let markMinorColor = UIColor(white: 0.7, alpha: 1.0)
	
	func markColorForIndexPath(indexPath: NSIndexPath) -> UIColor? {
		var index = Int(floor(minimumValue)) + indexPath.row
		if hasPartialItemBefore {
			index += 1
		}
		
		switch zoomMode {
		case .None:
			return markMajorColor
		case let .ZoomIn(count):
			if count == 2 {
				if index % 2 == 0 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 10 {
				if index % 10 == 0 {
					return markMajorColor
				}
				if abs(index % 10) == 5 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 20 {
				if index % 2 == 0 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 100 {
				if index % 10 == 0 {
					return markMajorColor
				}
				if abs(index % 10) == 5 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 200 {
				if index % 2 == 0 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 1000 {
				if index % 10 == 0 {
					return markMajorColor
				}
				if abs(index % 10) == 5 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
		case let .ZoomOut(count):
			if count == 5 {
				if index % 2 == 0 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 10 {
				return markMajorColor
			}
			if count == 50 {
				if index % 2 == 0 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 100 {
				return markMajorColor
			}
			if count == 500 {
				if index % 2 == 0 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 1000 {
				return markMajorColor
			}
			if count == 5000 {
				if index % 2 == 0 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 10000 {
				return markMajorColor
			}
			if count == 50000 {
				if index % 2 == 0 {
					return markMajorColor
				} else {
					return markMinorColor
				}
			}
			if count == 100000 {
				return markMajorColor
			}
		}
		return UIColor.redColor()
	}

	
	var debugDescription: String {
		var strings = [String]()
		strings.append("zoomMode: \(zoomMode)")
		strings.append(String(format: "scale: %.5f", scale))
		strings.append(String(format: "range: %.5f %.5f", minimumValue, maximumValue))
		if hasOnePartialItem {
			strings.append(String(format: "one-partial: %.5f", sizeOfOnePartialItem))
		}
		if hasPartialItemBefore {
			strings.append(String(format: "partial-before: %.5f", sizeOfPartialItemBefore))
		}
		strings.append("full: \(numberOfFullItems)")
		if hasPartialItemAfter {
			strings.append(String(format: "partial-after: %.5f", sizeOfPartialItemAfter))
		}
		return strings.joinWithSeparator(" , ")
	}
}
