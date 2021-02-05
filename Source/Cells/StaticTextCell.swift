// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit

public struct StaticTextCellModel {
	var title: String = ""
	var value: String = ""
    var titleFont: UIFont = .preferredFont(forTextStyle: .body)
    var detailFont: UIFont = .preferredFont(forTextStyle: .body)
    var detailTextColor: UIColor = Colors.secondaryText
    var titleTextColor: UIColor = Colors.text
}

public class StaticTextCell: UITableViewCell, AssignAppearance {
	public var model: StaticTextCellModel

	public init(model: StaticTextCellModel) {
		self.model = model
		super.init(style: .value1, reuseIdentifier: nil)
		loadWithModel(model)
        assignDefaultColors()
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func loadWithModel(_ model: StaticTextCellModel) {
		selectionStyle = .none
		textLabel?.text = model.title
		detailTextLabel?.text = model.value
        textLabel?.font = model.titleFont
        detailTextLabel?.font = model.detailFont
	}
    
    public func assignDefaultColors() {
        textLabel?.textColor = model.titleTextColor
        detailTextLabel?.textColor = model.detailTextColor
    }
    
    public func assignTintColors() {
        textLabel?.textColor = tintColor
        detailTextLabel?.textColor = tintColor
    }

}
