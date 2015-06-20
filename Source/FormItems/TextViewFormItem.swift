//
//  TextViewFormItem.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 20-06-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import Foundation

public class TextViewFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitTextView(self)
	}
	
	public var placeholder: String = ""
	public func placeholder(placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	typealias SyncBlock = (value: String) -> Void
	var syncCellWithValue: SyncBlock = { (string: String) in
		DLog("sync is not overridden")
	}
	
	internal var innerValue: String = ""
	public var value: String {
		get {
			return self.innerValue
		}
		set {
			self.assignValueAndSync(newValue)
		}
	}
	
	func assignValueAndSync(value: String) {
		innerValue = value
		syncCellWithValue(value: value)
	}
}
