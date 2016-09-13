// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

/// This is an invisible field, that is submitted along with the json
open class MetaFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var value: AnyObject?
	open func value(_ value: AnyObject?) -> Self {
		self.value = value
		return self
	}
}
