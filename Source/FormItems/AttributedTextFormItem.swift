// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
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
