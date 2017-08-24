// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

enum PrecisionSlider_InnerZoomMode {
	case none
	case zoomIn(count: UInt)
	case zoomOut(count: UInt)

	var scalar: Double {
		switch self {
		case .none:
			return 1
		case let .zoomIn(count):
			return Double(count)
		case let .zoomOut(count):
			return 1 / Double(count)
		}
	}

	static func create(_ zoom: Float) -> PrecisionSlider_InnerZoomMode {
		if zoom >  4.92 { return .zoomIn(count: 100000) }
		if zoom >  4.42 { return .zoomIn(count: 20000) }
		if zoom >  3.92 { return .zoomIn(count: 10000) }
		if zoom >  3.42 { return .zoomIn(count: 2000) }
		if zoom >  2.92 { return .zoomIn(count: 1000) }
		if zoom >  2.47 { return .zoomIn(count: 200) }
		if zoom >  1.91 { return .zoomIn(count: 100) }
		if zoom >  1.41 { return .zoomIn(count: 20) }
		if zoom >  0.90 { return .zoomIn(count: 10) }
		if zoom >  0.47 { return .zoomIn(count: 2) }
		if zoom >  0.00 { return .none }
		if zoom > -0.47 { return .zoomOut(count: 5) }
		if zoom > -1.00 { return .zoomOut(count: 10) }
		if zoom > -1.69 { return .zoomOut(count: 50) }
		if zoom > -2.00 { return .zoomOut(count: 100) }
		if zoom > -2.30 { return .zoomOut(count: 500) }
		if zoom > -2.97 { return .zoomOut(count: 1000) }
		if zoom > -3.87 { return .zoomOut(count: 5000) }
		if zoom > -4.07 { return .zoomOut(count: 10000) }
		if zoom > -4.87 { return .zoomOut(count: 50000) }
		return .zoomOut(count: 100000)
	}

	enum MarkerType {
	case major
	case minor
	case other
	}

	func markerType(index: Int) -> MarkerType {
		switch self {
		case .none:
			return .major
		case let .zoomIn(count):
			switch count {
			case 2, 20, 200, 2000, 20000:
				if index % 2 == 0 {
					return .major
				} else {
					return .minor
				}
			case 10, 100, 1000, 10000, 100000:
				if index % 10 == 0 {
					return .major
				}
				if abs(index % 10) == 5 {
					return .major
				} else {
					return .minor
				}
			default:
				return .other
			}
		case let .zoomOut(count):
			switch count {
			case 5, 50, 500, 5000, 50000:
				if index % 2 == 0 {
					return .major
				} else {
					return .minor
				}
			case 10, 100, 1000, 10000, 100000:
				return .major
			default:
				return .other
			}
		}
	}

	func modulo10String(_ index: Int) -> String {
		let displayValue = index % 10
		return String(displayValue)
	}

	func markerText(_ index: Int) -> String? {
		switch self {
		case .none:
			return modulo10String(index)
		case let .zoomIn(count):
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
		case let .zoomOut(count):
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
