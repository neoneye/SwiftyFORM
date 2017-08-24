// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

public class SegmentedControlFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	public var items: [String] = ["a", "b", "c"]

	@discardableResult
	public func items(_ items: String...) -> Self {
		self.items = items
		return self
	}

	@discardableResult
	public func itemsArray(_ items: [String]) -> Self {
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

	@discardableResult
	public func selected(_ selected: Int) -> Self {
		self.value = selected
		return self
	}

	typealias SyncBlock = (_ value: Int) -> Void
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
			syncCellWithValue(newValue)
		}
	}

	public typealias ValueDidChangeBlock = (_ value: Int) -> Void
	public var valueDidChangeBlock: ValueDidChangeBlock = { (value: Int) in
		SwiftyFormLog("not overridden")
	}

	public func valueDidChange(_ value: Int) {
		innerValue = value
		valueDidChangeBlock(value)
	}
}
