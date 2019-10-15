//
//  File.swift
//  
//
//  Created by Bradley Mackey on 15/10/2019.
//

import UIKit

protocol CustomizableTitleLabel {
    var title: String { get set }
    var titleFont: UIFont { get set }
    var titleTextColor: UIColor { get set }
}

typealias CustomizableLabels = CustomizableTitleLabel & CustomizableDetailLabel

extension CustomizableTitleLabel {
    
    @discardableResult
    public mutating func title(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    @discardableResult
    public mutating func titleFont(_ titleFont: UIFont) -> Self {
        self.titleFont = titleFont
        return self
    }
    
    @discardableResult
    public mutating func titleTextColor(_ titleTextColor: UIColor) -> Self {
        self.titleTextColor = titleTextColor
        return self
    }
    
}

protocol CustomizableDetailLabel {
    var detailFont: UIFont { get set }
    var detailTextColor: UIColor { get set }
}

extension CustomizableDetailLabel {
    
    @discardableResult
    public mutating func detailFont(_ detailFont: UIFont) -> Self {
        self.detailFont = detailFont
        return self
    }
    
    @discardableResult
    public mutating func detailTextColor(_ detailTextColor: UIColor) -> Self {
        self.detailTextColor = detailTextColor
        return self
    }
    
}
