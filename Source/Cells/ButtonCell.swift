// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public struct ButtonCellModel {
	var title: String = ""
	
	var action: Void -> Void = {
		DLog("action")
	}

}

public class ButtonCell: UITableViewCell, SelectRowDelegate {
	public let model: ButtonCellModel
	
	public init(model: ButtonCellModel) {
		self.model = model
		super.init(style: .Default, reuseIdentifier: nil)
		loadWithModel(model)
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func loadWithModel(model: ButtonCellModel) {
		textLabel?.text = model.title
		textLabel?.textAlignment = NSTextAlignment.Center
	}

	public func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView) {
		// hide keyboard when the user taps this kind of row
		tableView.form_firstResponder()?.resignFirstResponder()
		
		model.action()
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
}
