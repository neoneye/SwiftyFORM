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
//		case .none:
//			let view = UIView()
//			view.frame = CGRect(x: 0, y: 0, width: 1, height: CGFloat.leastNormalMagnitude)
//			return view
		case let .titleView(view):
			return view
		default:
			return nil
		}
	}
	
	var height: CGFloat {
//		return UITableViewAutomaticDimension
		switch self {
		case .none:
//			return CGFloat.leastNormalMagnitude
//			return 0.0001
			return CGFloat.leastNonzeroMagnitude
		case .systemDefault:
			return UITableViewAutomaticDimension
//			return 35
		case let .titleView(view):
			return view.frame.height
		case .titleString(_):
			return UITableViewAutomaticDimension
		}
	}
	
	var estimatedHeight: CGFloat {
//		return UITableViewAutomaticDimension
//		switch self {
//		case .none:
//			return 2
//		case .systemDefault:
//			return 44
//		case let .titleView(view):
//			let view2: UIView = view
//			return view2.frame.size.height
//		case .titleString(_):
//			return 44
//		}

		switch self {
		case .none:
			return 2
		case .systemDefault:
//			return 44
			return UITableViewAutomaticDimension
		//			return 35
		case let .titleView(view):
//			return UITableViewAutomaticDimension
			return view.frame.height
		case .titleString(_):
			return 44
//			return UITableViewAutomaticDimension
		}
	}
}
