//
//  AttributedTextCell.swift
//  SwiftyFORM
//
//  Created by Jungho Bang on 2016. 7. 5..
//  Copyright © 2016. Jungho Bang. All rights reserved.
//

import UIKit

public struct AttributedTextCellModel {
    var title: String = ""
    var value: String = ""
    var attribute: [String : AnyObject] = [:]
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
        textLabel?.attributedText = NSAttributedString(string: model.title, attributes: model.attribute)
        detailTextLabel?.text = model.value
    }
}
