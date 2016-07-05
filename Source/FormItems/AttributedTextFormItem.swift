//
//  AttributedTextFormItem.swift
//  SwiftyFORM
//
//  Created by Jungho Bang on 2016. 7. 5..
//  Copyright © 2016. Jungho Bang. All rights reserved.
//

import Foundation

public class AttributedTextFormItem: StaticTextFormItem {
    override func accept(visitor: FormItemVisitor) {
        visitor.visitAttributedText(self)
    }
    
    public var attribute: [String : AnyObject] = [:]
    public func attribute(attribute: [String : AnyObject]) -> Self {
        self.attribute = attribute
        return self
    }
}
