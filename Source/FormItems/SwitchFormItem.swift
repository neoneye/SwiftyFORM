// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class SwitchFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var title: String = ""
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
	
	public typealias SyncBlock = (_ value: Bool, _ animated: Bool) -> Void
	open var syncCellWithValue: SyncBlock = { (value: Bool, animated: Bool) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: Bool = false
	open var value: Bool {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	
	public typealias SwitchDidChangeBlock = (_ value: Bool) -> Void
	open var switchDidChangeBlock: SwitchDidChangeBlock = { (value: Bool) in
		SwiftyFormLog("not overridden")
	}
	
	open func switchDidChange(_ value: Bool) {
		innerValue = value
		switchDidChangeBlock(value)
	}
	
	open func setValue(_ value: Bool, animated: Bool) {
		innerValue = value
		syncCellWithValue(value, animated)
	}
}
