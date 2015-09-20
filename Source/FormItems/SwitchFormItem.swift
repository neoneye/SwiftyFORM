// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import Foundation

public class SwitchFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitSwitch(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	typealias SyncBlock = (value: Bool, animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: Bool, animated: Bool) in
		DLog("sync is not overridden")
	}
	
	internal var innerValue: Bool = false
	public var value: Bool {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	
	typealias SwitchDidChangeBlock = (value: Bool) -> Void
	var switchDidChangeBlock: SwitchDidChangeBlock = { (value: Bool) in
		DLog("not overridden")
	}
	
	public func switchDidChange(value: Bool) {
		innerValue = value
		switchDidChangeBlock(value: value)
	}
	
	public func setValue(value: Bool, animated: Bool) {
		innerValue = value
		syncCellWithValue(value: value, animated: animated)
	}
}
