// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public struct ButtonCellModel {
	var title: String = ""
	
	var action: (Void) -> Void = {
		SwiftyFormLog("action")
	}

}

open class ButtonCell: UITableViewCell, SelectRowDelegate {
	open let model: ButtonCellModel
	
	public init(model: ButtonCellModel) {
		self.model = model
		super.init(style: .default, reuseIdentifier: nil)
		loadWithModel(model)
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open func loadWithModel(_ model: ButtonCellModel) {
		textLabel?.text = model.title
		textLabel?.textAlignment = NSTextAlignment.center
	}

	open func form_didSelectRow(_ indexPath: IndexPath, tableView: UITableView) {
		// hide keyboard when the user taps this kind of row
		tableView.form_firstResponder()?.resignFirstResponder()
		
		model.action()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}
