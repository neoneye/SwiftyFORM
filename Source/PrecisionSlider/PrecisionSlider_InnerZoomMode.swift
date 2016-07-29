// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

enum PrecisionSlider_InnerZoomMode {
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
	
	static func create(scale: Double) -> PrecisionSlider_InnerZoomMode {
		if scale > 2500000      { return .ZoomIn(count: 100000) }
		if scale >  800000      { return .ZoomIn(count: 20000) }
		if scale >  250000      { return .ZoomIn(count: 10000) }
		if scale >   80000      { return .ZoomIn(count: 2000) }
		if scale >   25000      { return .ZoomIn(count: 1000) }
		if scale >    9000      { return .ZoomIn(count: 200) }
		if scale >    2500      { return .ZoomIn(count: 100) }
		if scale >     800      { return .ZoomIn(count: 20) }
		if scale >     250      { return .ZoomIn(count: 10) }
		if scale >     100      { return .ZoomIn(count: 2) }
		if scale >      30      { return .None }
		if scale >      10      { return .ZoomOut(count: 5) }
		if scale >       3      { return .ZoomOut(count: 10) }
		if scale >       0.6    { return .ZoomOut(count: 50) }
		if scale >       0.3    { return .ZoomOut(count: 100) }
		if scale >       0.15   { return .ZoomOut(count: 500) }
		if scale >       0.032  { return .ZoomOut(count: 1000) }
		if scale >       0.004  { return .ZoomOut(count: 5000) }
		if scale >       0.0025 { return .ZoomOut(count: 10000) }
		if scale >       0.0004 { return .ZoomOut(count: 50000) }
		return .ZoomOut(count: 100000)
	}
	
	enum MarkerType {
	case Major
	case Minor
	case Other
	}
	
	func markerType(index index: Int) -> MarkerType {
		switch self {
		case .None:
			return .Major
		case let .ZoomIn(count):
			switch count {
			case 2, 20, 200, 2000, 20000:
				if index % 2 == 0 {
					return .Major
				} else {
					return .Minor
				}
			case 10, 100, 1000, 10000, 100000:
				if index % 10 == 0 {
					return .Major
				}
				if abs(index % 10) == 5 {
					return .Major
				} else {
					return .Minor
				}
			default:
				return .Other
			}
		case let .ZoomOut(count):
			switch count {
			case 5, 50, 500, 5000, 50000:
				if index % 2 == 0 {
					return .Major
				} else {
					return .Minor
				}
			case 10, 100, 1000, 10000, 100000:
				return .Major
			default:
				return .Other
			}
		}
	}

	
	func modulo10String(index: Int) -> String {
		let displayValue = index % 10
		return String(displayValue)
	}
	
	func markerText(index: Int) -> String? {
		switch self {
		case .None:
			return modulo10String(index)
		case let .ZoomIn(count):
			switch count {
			case 2, 20, 200, 2000, 20000:
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			case 10, 100, 1000, 10000, 100000:
				if index % 10 != 0 {
					return nil
				}
				return modulo10String(index / 10)
			default:
				return nil
			}
		case let .ZoomOut(count):
			switch count {
			case 5, 50, 500, 5000, 50000:
				if index % 2 != 0 {
					return nil
				}
				return modulo10String(index / 2)
			case 10, 100, 1000, 10000, 100000:
				return modulo10String(index)
			default:
				return nil
			}
		}
	}

}
