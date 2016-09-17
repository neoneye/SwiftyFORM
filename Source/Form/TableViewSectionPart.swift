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
			return 0
		case .systemDefault:
			return UITableViewAutomaticDimension
		case let .titleView(view):
			return view.frame.height
		case .titleString(_):
			return UITableViewAutomaticDimension
		}
	}
	
	var estimatedHeight: CGFloat {
		switch self {
		case .none:
			/**
			We don't want any header/footer to be visible. The height should be zero pixels.
			However returning an estimated height smaller than 2 pixels 
			causes UITableView to think that the height is 44 pixels
			Thus the lowest estimated height we can return is 2 pixels
			*/
			return 2
		case .systemDefault:
			return UITableViewAutomaticDimension
		case let .titleView(view):
			return view.frame.height
		case .titleString(_):
			return 44
		}
	}
}
