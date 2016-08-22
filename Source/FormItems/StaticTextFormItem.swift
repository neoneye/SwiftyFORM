// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public class StaticTextFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	

	typealias SyncBlock = (value: String) -> Void
	var syncCellWithValue: SyncBlock = { (string: String) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: String = ""
	public var value: String {
		get {
			return self.innerValue
		}
		set {
			innerValue = newValue
			syncCellWithValue(value: innerValue)
		}
	}
	public func value(value: String) -> Self {
		self.value = value
		return self
	}
}
