// MIT license. Copyright (c) 2019 SwiftyFORM. All rights reserved.
import UIKit

public protocol CustomizableTitleLabel {
    var title: String { get set }
    var titleFont: UIFont { get set }
    var titleTextColor: UIColor { get set }
}

typealias CustomizableLabels = CustomizableTitleLabel & CustomizableDetailLabel

public extension CustomizableTitleLabel where Self: FormItem {
    
    @discardableResult
    func title(_ title: String) -> Self {
        var instance = self
        instance.title = title
        return instance
    }
    
    @discardableResult
    func titleFont(_ titleFont: UIFont) -> Self {
        var instance = self
        instance.titleFont = titleFont
        return instance
    }
    
    @discardableResult
    func titleTextColor(_ titleTextColor: UIColor) -> Self {
        var instance = self
        instance.titleTextColor = titleTextColor
        return instance
    }
    
}

public protocol CustomizableDetailLabel {
    var detailFont: UIFont { get set }
    var detailTextColor: UIColor { get set }
}

public extension CustomizableDetailLabel where Self: FormItem {
    
    @discardableResult
    func detailFont(_ detailFont: UIFont) -> Self {
        var instance = self
        instance.detailFont = detailFont
        return instance
    }
    
    @discardableResult
    func detailTextColor(_ detailTextColor: UIColor) -> Self {
        var instance = self
        instance.detailTextColor = detailTextColor
        return instance
    }
    
}
