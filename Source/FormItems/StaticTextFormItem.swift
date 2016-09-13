// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class StaticTextFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var title: String = ""
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
	

	typealias SyncBlock = (_ value: String) -> Void
	var syncCellWithValue: SyncBlock = { (string: String) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: String = ""
	open var value: String {
		get {
			return self.innerValue
		}
		set {
			innerValue = newValue
			syncCellWithValue(innerValue)
		}
	}
	open func value(_ value: String) -> Self {
		self.value = value
		return self
	}
}
