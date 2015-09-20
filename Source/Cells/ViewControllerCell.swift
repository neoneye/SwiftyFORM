// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public class ViewControllerFormItemCellModel {
	public let title: String
	public let placeholder: String
	public init(title: String, placeholder: String) {
		self.title = title
		self.placeholder = placeholder
	}
}


public class ViewControllerFormItemCell: UITableViewCell, SelectRowDelegate {
	public let model: ViewControllerFormItemCellModel
	let innerDidSelectRow: (ViewControllerFormItemCell, ViewControllerFormItemCellModel) -> Void

	public init(model: ViewControllerFormItemCellModel, didSelectRow: (ViewControllerFormItemCell, ViewControllerFormItemCellModel) -> Void) {
		self.model = model
		self.innerDidSelectRow = didSelectRow
		super.init(style: .Value1, reuseIdentifier: nil)
		accessoryType = .DisclosureIndicator
		textLabel?.text = model.title
		detailTextLabel?.text = model.placeholder
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView) {
		DLog("will invoke")
		// hide keyboard when the user taps this kind of row
		tableView.form_firstResponder()?.resignFirstResponder()

		innerDidSelectRow(self, model)
		DLog("did invoke")
	}
}
