// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
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
			/**
			Returning too low values can causes expand/collapse to crash.
			The crash happens in UITableView.deleteRows() when tapping collapse.
			Solution is to ensure that the value never drops below 10 pixels.
			*/
			return max(view.frame.height, 10)
		case let .titleString(string):
			/**
			Argh, we cannot simply return UITableViewAutomaticDimension
			If we do then sections titles will show up with the wrong heights.
			
			In order for UITableView to automatically figure the height, we must return 44 pixels.
			Apple's default estimate is 44 pixels when data is coming from
			UITableViewDelegate.tableView(titleForHeaderInSection)
			So we have to return 44 pixels, then UITableView will assign a suitable
			size to the section header.
			
			UITableView works best with section titles that spans just a single line.
			However with multiline titles then expand/collapse animations becomes crash prone.
			So with longer texts then the estimate must be greater than 44 pixels.

			Poor mans solution for now
			short texts then return 44
			long texts then return 88
			
			The right solution would be to consider font size, screen size for determining the label height.
			This may be overfitting the problem.
			*/
			if string.characters.count > 50 {
				print("WARNING: Multiline section texts may cause crashes, consider instead using SectionHeaderViewFormItem")
				return Constant.estimatedHeightForTitleSection * 2
			}
			return Constant.estimatedHeightForTitleSection
		}
	}

	struct Constant {
		/// Default height of a section header with a title
		/// Apple doesn't seem to have any constant for this
		static let estimatedHeightForTitleSection: CGFloat = 44
	}
}
