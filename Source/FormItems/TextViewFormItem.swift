// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit

public class TextViewFormItem: FormItem, CustomizableTitleLabel {
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
    
    public var placeholderTextColor: UIColor = Colors.secondaryText

	typealias SyncBlock = (_ value: String) -> Void
	var syncCellWithValue: SyncBlock = { (string: String) in
		SwiftyFormLog("sync is not overridden")
	}

	internal var innerValue: String = ""
	public var value: String {
		get {
			self.innerValue
		}
		set {
			self.assignValueAndSync(newValue)
		}
	}

	func assignValueAndSync(_ value: String) {
		innerValue = value
		syncCellWithValue(value)
	}
}
