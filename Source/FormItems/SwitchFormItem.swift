// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public class SwitchFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	public typealias SyncBlock = (value: Bool, animated: Bool) -> Void
	public var syncCellWithValue: SyncBlock = { (value: Bool, animated: Bool) in
		SwiftyFormLog("sync is not overridden")
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
	
	public typealias SwitchDidChangeBlock = (value: Bool) -> Void
	public var switchDidChangeBlock: SwitchDidChangeBlock = { (value: Bool) in
		SwiftyFormLog("not overridden")
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
