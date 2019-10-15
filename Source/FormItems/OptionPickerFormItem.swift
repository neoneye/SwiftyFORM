// MIT license. Copyright (c) 2018 SwiftyFORM. All rights reserved.
import UIKit

public class OptionRowModel: CustomStringConvertible {
	public let title: String
	public let identifier: String

	public init(_ title: String, _ identifier: String) {
		self.title = title
		self.identifier = identifier
	}

	public var description: String {
		"\(title)-\(identifier)"
	}
}

public class OptionPickerFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var placeholder: String = ""

	@discardableResult
	public func placeholder(_ placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}
    
    public var titleFont: UIFont = .preferredFont(forTextStyle: .body)
    
    @discardableResult
    public func titleFont(_ titleFont: UIFont) -> Self {
        self.titleFont = titleFont
        return self
    }
    
    public var titleTextColor: UIColor = Colors.text
    
    @discardableResult
    public func titleTextColor(_ titleTextColor: UIColor) -> Self {
        self.titleTextColor = titleTextColor
        return self
    }
    
    public var detailFont: UIFont = .preferredFont(forTextStyle: .body)
    
    @discardableResult
    public func detailFont(_ detailFont: UIFont) -> Self {
        self.detailFont = detailFont
        return self
    }
    
    public var detailTextColor: UIColor = Colors.text
    
    @discardableResult
    public func detailTextColor(_ detailTextColor: UIColor) -> Self {
        self.detailTextColor = detailTextColor
        return self
    }

	public var options = [OptionRowModel]()

	@discardableResult
	public func append(_ name: String, identifier: String? = nil) -> Self {
		options.append(OptionRowModel(name, identifier ?? name))
		return self
	}

	public func selectOptionWithTitle(_ title: String) {
		for option in options {
			if option.title == title {
				self.setSelectedOptionRow(option)
				SwiftyFormLog("initial selected option: \(option)")
			}
		}
	}

	public func selectOptionWithIdentifier(_ identifier: String) {
		for option in options {
			if option.identifier == identifier {
				self.setSelectedOptionRow(option)
				SwiftyFormLog("initial selected option: \(option)")
			}
		}
	}

	public typealias SyncBlock = (_ selected: OptionRowModel?) -> Void
	public var syncCellWithValue: SyncBlock = { (selected: OptionRowModel?) in
		SwiftyFormLog("sync is not overridden")
	}

	internal var innerSelected: OptionRowModel?
	public var selected: OptionRowModel? {
		get {
			return self.innerSelected
		}
		set {
			self.setSelectedOptionRow(newValue)
		}
	}

	public func setSelectedOptionRow(_ selected: OptionRowModel?) {
		SwiftyFormLog("option: \(String(describing: selected?.title))")
		innerSelected = selected
		syncCellWithValue(selected)
	}

	public typealias ValueDidChange = (_ selected: OptionRowModel?) -> Void
	public var valueDidChange: ValueDidChange = { (selected: OptionRowModel?) in
		SwiftyFormLog("value did change not overridden")
	}
}

public class OptionRowFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""
    
    @discardableResult
    public func title(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    public var font: UIFont = .preferredFont(forTextStyle: .body)
    
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    public var textColor: UIColor = Colors.text
    
    @discardableResult
    public func textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }

	public var selected: Bool = false

	public var context: AnyObject?
}
