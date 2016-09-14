// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class TextViewFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}
	
	open var placeholder: String = ""

	@discardableResult
	open func placeholder(_ placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}
	
	open var title: String = ""

	@discardableResult
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
			self.assignValueAndSync(newValue)
		}
	}
	
	func assignValueAndSync(_ value: String) {
		innerValue = value
		syncCellWithValue(value)
	}
}
