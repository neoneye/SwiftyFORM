// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import Foundation

public class ButtonFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitButton(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	public var action: Void -> Void = {}
}
