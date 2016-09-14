// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class StepperFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	open var title: String = ""
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	typealias SyncBlock = (_ value: Int, _ animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: Int, animated: Bool) in
		SwiftyFormLog("sync is not overridden")
	}

	internal var innerValue: Int = 0
	open var value: Int {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}

	open func setValue(_ value: Int, animated: Bool) {
		innerValue = value
		syncCellWithValue(value, animated)
	}
}
