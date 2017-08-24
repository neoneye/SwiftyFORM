// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

public class ButtonFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	public var action: () -> Void = {}
}
