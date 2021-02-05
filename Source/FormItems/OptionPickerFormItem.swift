// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
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

public class OptionPickerFormItem: FormItem, CustomizableLabel {
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
    
    public var titleFont: UIFont = .preferredFont(forTextStyle: .body)
    
    public var titleTextColor: UIColor = Colors.text
    
    public var detailFont: UIFont = .preferredFont(forTextStyle: .body)
    
    public var detailTextColor: UIColor = Colors.secondaryText
    
	public var options = [OptionRowModel]()

	@discardableResult
	public func append(_ name: String, identifier: String? = nil) -> Self {
		options.append(OptionRowModel(name, identifier ?? name))
		return self
	}

	@discardableResult
	public func append(_ names: [String]) -> Self {
		options += names.map { OptionRowModel($0, $0) }
		return self
	}

	@discardableResult
	public func append(_ rows: OptionRowModel...) -> Self {
		options += rows
		return self
	}

	public func selectOptionWithTitle(_ title: String) {
		guard let option = options.first(where: { $0.title == title }) else { return }
		self.setSelectedOptionRow(option)
		SwiftyFormLog("initial selected option: \(option)")
	}

	public func selectOptionWithIdentifier(_ identifier: String) {
		guard let option = options.first(where: { $0.identifier == identifier }) else { return }
		self.setSelectedOptionRow(option)
		SwiftyFormLog("initial selected option: \(option)")
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

public class OptionRowFormItem: FormItem, CustomizableTitleLabel {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""
    
    public var titleFont: UIFont = .preferredFont(forTextStyle: .body)
    
    public var titleTextColor: UIColor = Colors.text

	public var selected: Bool = false

	public var context: AnyObject?
    
}
