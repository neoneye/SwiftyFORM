// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public class SegmentedControlFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitSegmentedControl(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	public var items: [String] = ["a", "b", "c"]
	public func items(items: String...) -> Self {
		self.items = items
		return self
	}
	public func itemsArray(items: [String]) -> Self {
		self.items = items
		return self
	}
	
	public var selectedItem: String? {
		let index = selected
		if index >= 0 || index < items.count {
			return items[index]
		}
		return nil
	}

	public var selected: Int {
		get { return value }
		set { self.value = newValue }
	}

	public func selected(selected: Int) -> Self {
		self.value = selected
		return self
	}
	
	
	typealias SyncBlock = (value: Int) -> Void
	var syncCellWithValue: SyncBlock = { (value: Int) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: Int = 0
	public var value: Int {
		get {
			return innerValue
		}
		set {
			innerValue = newValue
			syncCellWithValue(value: newValue)
		}
	}
	
	public typealias ValueDidChangeBlock = (value: Int) -> Void
	public var valueDidChangeBlock: ValueDidChangeBlock = { (value: Int) in
		SwiftyFormLog("not overridden")
	}
	
	public func valueDidChange(value: Int) {
		innerValue = value
		valueDidChangeBlock(value: value)
	}
}
