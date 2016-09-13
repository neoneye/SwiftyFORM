// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

open class ViewControllerFormItemCellModel {
	open let title: String
	open let placeholder: String
	public init(title: String, placeholder: String) {
		self.title = title
		self.placeholder = placeholder
	}
}


open class ViewControllerFormItemCell: UITableViewCell, SelectRowDelegate {
	open let model: ViewControllerFormItemCellModel
	let innerDidSelectRow: (ViewControllerFormItemCell, ViewControllerFormItemCellModel) -> Void

	public init(model: ViewControllerFormItemCellModel, didSelectRow: @escaping (ViewControllerFormItemCell, ViewControllerFormItemCellModel) -> Void) {
		self.model = model
		self.innerDidSelectRow = didSelectRow
		super.init(style: .value1, reuseIdentifier: nil)
		accessoryType = .disclosureIndicator
		textLabel?.text = model.title
		detailTextLabel?.text = model.placeholder
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open func form_didSelectRow(_ indexPath: IndexPath, tableView: UITableView) {
		SwiftyFormLog("will invoke")
		// hide keyboard when the user taps this kind of row
		tableView.form_firstResponder()?.resignFirstResponder()

		innerDidSelectRow(self, model)
		SwiftyFormLog("did invoke")
	}
}
