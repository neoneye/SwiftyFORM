//
//  SelectOptionDelegate.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 13/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import Foundation

@objc public protocol SelectOptionDelegate {
	func form_willSelectOption(option: OptionRowFormItem)
}