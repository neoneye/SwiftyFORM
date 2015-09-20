// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import Foundation

public class StepperFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitStepper(self)
	}

	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}

	typealias SyncBlock = (value: Int, animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: Int, animated: Bool) in
		DLog("sync is not overridden")
	}

	internal var innerValue: Int = 0
	public var value: Int {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}

	public func setValue(value: Int, animated: Bool) {
		innerValue = value
		syncCellWithValue(value: value, animated: animated)
	}
}
