// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit

public protocol CustomizableButtons {
    var backgroundColor: UIColor? { get set }
}

public extension CustomizableButtons where Self: FormItem {
    
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        var instance = self
        instance.backgroundColor = color
        return instance
    }
    
}
