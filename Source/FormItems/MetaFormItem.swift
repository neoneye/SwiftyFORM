//
//  MetaFormItem.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 20-06-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import Foundation

/// This is an invisible field, that is submitted along with the json
public class MetaFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitMeta(self)
	}
	
	public var value: AnyObject?
	public func value(value: AnyObject?) -> Self {
		self.value = value
		return self
	}
}
