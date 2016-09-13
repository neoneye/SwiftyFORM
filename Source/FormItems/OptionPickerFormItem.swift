// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class OptionRowModel: CustomStringConvertible {
	open let title: String
	open let identifier: String
	
	public init(_ title: String, _ identifier: String) {
		self.title = title
		self.identifier = identifier
	}
	
	open var description: String {
		return "\(title)-\(identifier)"
	}
}

open class OptionPickerFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var placeholder: String = ""
	open func placeholder(_ placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}
	
	open var title: String = ""
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
	
	open var options = [OptionRowModel]()
	open func append(_ name: String, identifier: String? = nil) -> Self {
		options.append(OptionRowModel(name, identifier ?? name))
		return self
	}
	
	open func selectOptionWithTitle(_ title: String) {
		for option in options {
			if option.title == title {
				self.setSelectedOptionRow(option)
				SwiftyFormLog("initial selected option: \(option)")
			}
		}
	}
	
	open func selectOptionWithIdentifier(_ identifier: String) {
		for option in options {
			if option.identifier == identifier {
				self.setSelectedOptionRow(option)
				SwiftyFormLog("initial selected option: \(option)")
			}
		}
	}

	public typealias SyncBlock = (_ selected: OptionRowModel?) -> Void
	open var syncCellWithValue: SyncBlock = { (selected: OptionRowModel?) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerSelected: OptionRowModel? = nil
	open var selected: OptionRowModel? {
		get {
			return self.innerSelected
		}
		set {
			self.setSelectedOptionRow(newValue)
		}
	}
	
	open func setSelectedOptionRow(_ selected: OptionRowModel?) {
		SwiftyFormLog("option: \(selected?.title)")
		innerSelected = selected
		syncCellWithValue(selected)
	}
	
	public typealias ValueDidChange = (_ selected: OptionRowModel?) -> Void
	open var valueDidChange: ValueDidChange = { (selected: OptionRowModel?) in
		SwiftyFormLog("value did change not overridden")
	}
}

open class OptionRowFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var title: String = ""
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
	
	open var selected: Bool = false
	
	open var context: AnyObject?
}
