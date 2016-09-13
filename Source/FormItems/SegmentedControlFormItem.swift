// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class SegmentedControlFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var title: String = ""
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
	
	open var items: [String] = ["a", "b", "c"]
	open func items(_ items: String...) -> Self {
		self.items = items
		return self
	}
	open func itemsArray(_ items: [String]) -> Self {
		self.items = items
		return self
	}
	
	open var selectedItem: String? {
		let index = selected
		if index >= 0 || index < items.count {
			return items[index]
		}
		return nil
	}

	open var selected: Int {
		get { return value }
		set { self.value = newValue }
	}

	open func selected(_ selected: Int) -> Self {
		self.value = selected
		return self
	}
	
	
	typealias SyncBlock = (_ value: Int) -> Void
	var syncCellWithValue: SyncBlock = { (value: Int) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: Int = 0
	open var value: Int {
		get {
			return innerValue
		}
		set {
			innerValue = newValue
			syncCellWithValue(newValue)
		}
	}
	
	public typealias ValueDidChangeBlock = (_ value: Int) -> Void
	open var valueDidChangeBlock: ValueDidChangeBlock = { (value: Int) in
		SwiftyFormLog("not overridden")
	}
	
	open func valueDidChange(_ value: Int) {
		innerValue = value
		valueDidChangeBlock(value)
	}
}
