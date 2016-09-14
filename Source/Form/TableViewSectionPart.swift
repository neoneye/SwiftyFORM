// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public enum TableViewSectionPart {
	case none
	case titleString(string: String)
	case titleView(view: UIView)
	
	typealias CreateBlock = (Void) -> TableViewSectionPart
	
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
		case let .titleView(view):
			let view2: UIView = view
			return view2.frame.size.height
		default:
			return UITableViewAutomaticDimension
		}
	}
}
