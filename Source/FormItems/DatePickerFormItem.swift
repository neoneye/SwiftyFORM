// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
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
open class DatePickerFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var title: String = ""
	open func title(_ title: String) -> Self {
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
	open var behavior = Behavior.collapsed
	open func behavior(_ behavior: Behavior) -> Self {
		self.behavior = behavior
		return self
	}
	
	typealias SyncBlock = (_ date: Date, _ animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (date: Date, animated: Bool) in
		SwiftyFormLog("sync is not overridden: \(date)")
	}
	
	internal var innerValue = Date()
	open var value: Date {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	
	open func setValue(_ date: Date, animated: Bool) {
		innerValue = date
		syncCellWithValue(date, animated)
	}
	
	open var datePickerMode: DatePickerFormItemMode = .dateAndTime
	open var locale: Locale? // default is [NSLocale currentLocale]. setting nil returns to default
	open var minimumDate: Date? // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
	open var maximumDate: Date? // default is nil
	
	
	public typealias ValueDidChangeBlock = (_ value: Date) -> Void
	open var valueDidChangeBlock: ValueDidChangeBlock = { (value: Date) in
		SwiftyFormLog("not overridden")
	}
	
	open func valueDidChange(_ value: Date) {
		innerValue = value
		valueDidChangeBlock(value)
	}
}
