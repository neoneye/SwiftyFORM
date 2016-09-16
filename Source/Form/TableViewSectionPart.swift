// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public enum TableViewSectionPart {
	case none
	case systemDefault
	case titleString(string: String)
	case titleView(view: UIView)
	
	var title: String? {
		switch self {
		case let .titleString(string):
			return string
		default:
			return nil
		}
	}
	
	var view: UIView? {
		switch self {
		case let .titleView(view):
			return view
		default:
			return nil
		}
	}
	
	var height: CGFloat {
		switch self {
		case .none:
			return CGFloat.leastNormalMagnitude
		case .systemDefault:
			return 35
		case let .titleView(view):
			let view2: UIView = view
			return view2.frame.size.height
		case .titleString(_):
			return UITableViewAutomaticDimension
		}
	}
}
