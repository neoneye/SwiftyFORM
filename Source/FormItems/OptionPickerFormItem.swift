//
//  OptionPickerFormItem.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 20-06-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import Foundation

public class OptionRowModel {
	public let title: String
	public let identifier: String
	
	public init(_ title: String, _ identifier: String) {
		self.title = title
		self.identifier = identifier
	}
}

public class OptionPickerFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitOptionPicker(self)
	}
	
	public var placeholder: String = ""
	public func placeholder(placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	public var options = [OptionRowModel]()
	public func append(name: String, identifier: String? = nil) -> Self {
		options.append(OptionRowModel(name, identifier ?? name))
		return self
	}
	
	public func selectOptionWithTitle(title: String) {
		for option in options {
			if option.title == title {
				self.setSelectedOptionRow(option)
				DLog("initial selected option: \(option.title)")
			}
		}
	}
	
	typealias SyncBlock = (selected: OptionRowModel?) -> Void
	var syncCellWithValue: SyncBlock = { (selected: OptionRowModel?) in
		DLog("sync is not overridden")
	}
	
	internal var innerSelected: OptionRowModel? = nil
	public var selected: OptionRowModel? {
		get {
			return self.innerSelected
		}
		set {
			self.setSelectedOptionRow(newValue)
		}
	}
	
	public func setSelectedOptionRow(selected: OptionRowModel?) {
		DLog("option: \(selected?.title)")
		innerSelected = selected
		syncCellWithValue(selected: selected)
	}
}

public class OptionRowFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitOptionRow(self)
	}
	
	public var title: String = ""
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
	
	public var selected: Bool = false
	
	public var context: AnyObject?
}
