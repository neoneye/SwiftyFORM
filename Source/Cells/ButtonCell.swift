// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit

public struct ButtonCellModel {
	var title: String = ""
    var titleFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    var textAlignment: NSTextAlignment = .center
    var titleTextColor: UIColor = Colors.text
    var backgroundColor: UIColor? = nil

	var action: () -> Void = {
		SwiftyFormLog("action")
	}

}

public class ButtonCell: UITableViewCell, SelectRowDelegate, AssignAppearance {
	public let model: ButtonCellModel

	public init(model: ButtonCellModel) {
		self.model = model
		super.init(style: .default, reuseIdentifier: nil)
		loadWithModel(model)
        
        assignDefaultColors()
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func loadWithModel(_ model: ButtonCellModel) {
		textLabel?.text = model.title
        textLabel?.font = model.titleFont
        textLabel?.textAlignment = model.textAlignment
        backgroundColor = model.backgroundColor
	}

	public func form_didSelectRow(indexPath: IndexPath, tableView: UITableView) {
		// hide keyboard when the user taps this kind of row
		tableView.form_firstResponder()?.resignFirstResponder()

		model.action()

		tableView.deselectRow(at: indexPath, animated: true)
	}
    
    public func assignDefaultColors() {
        textLabel?.textColor = model.titleTextColor
    }
    
    public func assignTintColors() {
        textLabel?.textColor = tintColor
    }
    
}
