// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class ButtonFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var title: String = ""
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
	
	open var action: (Void) -> Void = {}
}
