//
//  Colors.swift
//
//  Created by Bradley Mackey on 12/10/2019.
//

import UIKit

/// dynamic (light/dark) colors for iOS 13+
/// for iOS <13, the light varient will be used
struct Colors {
    
    @DynamicUIColor(light: .white, dark: .black)
    static var background: UIColor
    
    @DynamicUIColor(light: .black, dark: .white)
    static var text: UIColor
    
    @DynamicUIColor(light: .gray, dark: .lightGray)
    static var secondaryText: UIColor
    
    @DynamicUIColor(light: UIColor(white: 0.9, alpha: 1), dark: .black)
    static var mutedBackground: UIColor
    
}
