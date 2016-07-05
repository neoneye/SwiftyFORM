// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public struct AttributedTextCellModel {
	var titleAttributedText: NSAttributedString?
	var valueAttributedText: NSAttributedString?
}

public class AttributedTextCell: UITableViewCell {
    public var model: AttributedTextCellModel
    
    public init(model: AttributedTextCellModel) {
        self.model = model
        super.init(style: .Value1, reuseIdentifier: nil)
        loadWithModel(model)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadWithModel(model: AttributedTextCellModel) {
        selectionStyle = .None
        textLabel?.attributedText = model.titleAttributedText
        detailTextLabel?.attributedText = model.valueAttributedText
    }
}
