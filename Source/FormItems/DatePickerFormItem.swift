// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public enum DatePickerFormItemMode {
	case Time
	case Date
	case DateAndTime
	
	var description: String {
		switch self {
		case .Time: return "Time"
		case .Date: return "Date"
		case .DateAndTime: return "DateAndTime"
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
		visitor.visit(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	/**
	### Collapsed
	
	When the `behavior` is set to `Collapsed` then
	date picker starts out being hidden.
	
	The user has to tap the row to expand it.
	This will cause other inline date pickers to collapse.
	

	### Expanded
	
	When the `behavior` is set to `Expanded` then
	date picker starts out being visible.
	
	The user has to tap the row to collapse it.
	Or if another control becomes first respond this will collapse it.
	When the keyboard appears this will collapse it.
	
	
	### ExpandedAlways
	
	When the `behavior` is set to `ExpandedAlways` then
	the date picker is always expanded. It cannot be collapsed.
	It is not affected by `becomeFirstResponder()` nor `resignFirstResponder()`.
	*/
	public enum Behavior {
		case Collapsed
		case Expanded
		case ExpandedAlways
	}
	public var behavior = Behavior.Collapsed
	public func behavior(behavior: Behavior) -> Self {
		self.behavior = behavior
		return self
	}
	
	typealias SyncBlock = (date: NSDate, animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (date: NSDate, animated: Bool) in
		SwiftyFormLog("sync is not overridden: \(date)")
	}
	
	internal var innerValue = NSDate()
	public var value: NSDate {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}
	
	public func setValue(date: NSDate, animated: Bool) {
		innerValue = date
		syncCellWithValue(date: date, animated: animated)
	}
	
	public var datePickerMode: DatePickerFormItemMode = .DateAndTime
	public var locale: NSLocale? // default is [NSLocale currentLocale]. setting nil returns to default
	public var minimumDate: NSDate? // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
	public var maximumDate: NSDate? // default is nil
	
	
	public typealias ValueDidChangeBlock = (value: NSDate) -> Void
	public var valueDidChangeBlock: ValueDidChangeBlock = { (value: NSDate) in
		SwiftyFormLog("not overridden")
	}
	
	public func valueDidChange(value: NSDate) {
		innerValue = value
		valueDidChangeBlock(value: value)
	}
}
