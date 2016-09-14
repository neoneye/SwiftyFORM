// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class ButtonFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}
	
	open var title: String = ""

	@discardableResult
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
	
	open var action: (Void) -> Void = {}
}
