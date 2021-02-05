// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit

public class StaticTextFormItem: FormItem, CustomizableLabel {
    
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""

    public var titleFont: UIFont = .preferredFont(forTextStyle: .body)
    
    public var detailFont: UIFont = .preferredFont(forTextStyle: .body)
    
    public var titleTextColor: UIColor = Colors.text
    
    public var detailTextColor: UIColor = Colors.secondaryText

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
			innerValue = newValue
			syncCellWithValue(innerValue)
		}
	}

	@discardableResult
	public func value(_ value: String) -> Self {
		self.value = value
		return self
	}
}
