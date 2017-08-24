// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

public struct AttributedTextCellModel {
	var titleAttributedText: NSAttributedString?
	var valueAttributedText: NSAttributedString?
}

public class AttributedTextCell: UITableViewCell {
    public var model: AttributedTextCellModel

    public init(model: AttributedTextCellModel) {
        self.model = model
        super.init(style: .value1, reuseIdentifier: nil)
        loadWithModel(model)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadWithModel(_ model: AttributedTextCellModel) {
        selectionStyle = .none
        textLabel?.attributedText = model.titleAttributedText
        detailTextLabel?.attributedText = model.valueAttributedText
    }
}
