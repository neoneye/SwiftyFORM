// THE FOLLOWING CONTAINS ADAPTED SOURCE CODE FROM:
// https://github.com/guillermomuntaner/Burritos

// Copyright 2019 Guillermo Muntaner
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//
//  DynamicUIColor.swift
//
//
//  Created by Guillermo Muntaner Perelló on 19/06/2019.
//  Original credit to @bardonadam
//

import UIKit

@propertyWrapper
public struct DynamicUIColor {

    /// Backwards compatible wrapper arround UIUserInterfaceStyle
    public enum Style {
        case light, dark
    }
    
    let light: UIColor
    let dark: UIColor
    let styleProvider: () -> Style?

    public init(
        light: UIColor,
        dark: UIColor,
        style: @autoclosure @escaping () -> Style? = nil
    ) {
        self.light = light
        self.dark = dark
        self.styleProvider = style
    }

    public var wrappedValue: UIColor {
        switch styleProvider() {
        case .dark: return dark
        case .light: return light
        case .none:
            if #available(iOS 13.0, tvOS 13.0, *) {
                return UIColor { traitCollection -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                    case .dark: return self.dark
                    case .light, .unspecified: return self.light
                    @unknown default: return self.light
                    }
                }
            } else {
                return light
            }
        }
    }
}
