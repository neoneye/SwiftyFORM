// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

public enum DatePickerFormItemMode {
	case time
	case date
	case dateAndTime

	var description: String {
		switch self {
		case .time: return "Time"
		case .date: return "Date"
		case .dateAndTime: return "DateAndTime"
		}
	}
}

/**
# Inline date picker

### Tap to expand/collapse

Behind the scenes this creates a `UIDatePicker`.
*/
public class DatePickerFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	/**
	### Collapsed
	
	When the `behavior` is set to `Collapsed` then
	the date picker starts out being hidden.
	
	The user has to tap the row to expand it.
	This will collapse other inline date pickers.
	

	### Expanded
	
	When the `behavior` is set to `Expanded` then
	the date picker starts out being visible.
	
	The user has to tap the row to collapse it.
	Or if another control becomes first respond this will collapse it.
	When the keyboard appears this will collapse it.
	
	
	### ExpandedAlways
	
	When the `behavior` is set to `ExpandedAlways` then
	the date picker is always expanded. It cannot be collapsed.
	It is not affected by `becomeFirstResponder()` nor `resignFirstResponder()`.
	*/
	public enum Behavior {
		case collapsed
		case expanded
		case expandedAlways
	}
	public var behavior = Behavior.collapsed

	@discardableResult
	public func behavior(_ behavior: Behavior) -> Self {
		self.behavior = behavior
		return self
	}

	typealias SyncBlock = (_ date: Date, _ animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (date: Date, animated: Bool) in
		SwiftyFormLog("sync is not overridden: \(date)")
	}

	internal var innerValue = Date()
	public var value: Date {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}

	public func setValue(_ date: Date, animated: Bool) {
		innerValue = date
		syncCellWithValue(date, animated)
	}

	public var datePickerMode: DatePickerFormItemMode = .dateAndTime
	public var locale: Locale? // default is Locale.current, setting nil returns to default
	public var minimumDate: Date? // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
	public var maximumDate: Date? // default is nil
	public var minuteInterval: Int = 1

	public typealias ValueDidChangeBlock = (_ value: Date) -> Void
	public var valueDidChangeBlock: ValueDidChangeBlock = { (value: Date) in
		SwiftyFormLog("not overridden")
	}

	public func valueDidChange(_ value: Date) {
		innerValue = value
		valueDidChangeBlock(value)
	}
}
