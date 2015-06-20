//
//  SwitchFormItem.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 20-06-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import Foundation

public class SwitchFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitSwitch(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	typealias SyncBlock = (value: Bool, animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: Bool, animated: Bool) in
		DLog("sync is not overridden")
	}
	
	internal var innerValue: Bool = false
	public var value: Bool {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	
	public func setValue(value: Bool, animated: Bool) {
		innerValue = value
		syncCellWithValue(value: value, animated: animated)
	}
}
