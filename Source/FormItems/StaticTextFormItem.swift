//
//  StaticTextFormItem.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 20-06-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import Foundation

public class StaticTextFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitStaticText(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	public var value: String = ""
	public func value(value: String) -> Self {
		self.value = value
		return self
	}
}
