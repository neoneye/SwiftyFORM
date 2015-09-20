// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
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
