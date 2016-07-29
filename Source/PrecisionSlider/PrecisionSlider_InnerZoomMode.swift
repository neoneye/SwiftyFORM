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
		if scale > 25000      { return .ZoomIn(count: 1000) }
		if scale >  9000      { return .ZoomIn(count: 200) }
		if scale >  2500      { return .ZoomIn(count: 100) }
		if scale >   800      { return .ZoomIn(count: 20) }
		if scale >   250      { return .ZoomIn(count: 10) }
		if scale >   100      { return .ZoomIn(count: 2) }
		if scale >    30      { return .None }
		if scale >    10      { return .ZoomOut(count: 5) }
		if scale >     3      { return .ZoomOut(count: 10) }
		if scale >     0.6    { return .ZoomOut(count: 50) }
		if scale >     0.3    { return .ZoomOut(count: 100) }
		if scale >     0.15   { return .ZoomOut(count: 500) }
		if scale >     0.032  { return .ZoomOut(count: 1000) }
		if scale >     0.004  { return .ZoomOut(count: 5000) }
		if scale >     0.0025 { return .ZoomOut(count: 10000) }
		if scale >     0.0004 { return .ZoomOut(count: 50000) }
		return .ZoomOut(count: 100000)
	}
}
