// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit

public class SwitchFormItem: FormItem, CustomizableTitleLabel {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""
    
    public var titleFont: UIFont = .preferredFont(forTextStyle: .body)
    
    public var titleTextColor: UIColor = Colors.text
	

	public typealias SyncBlock = (_ value: Bool, _ animated: Bool) -> Void
	public var syncCellWithValue: SyncBlock = { (value: Bool, animated: Bool) in
		SwiftyFormLog("sync is not overridden")
	}

	internal var innerValue: Bool = false
	public var value: Bool {
		get {
			self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}

	public typealias SwitchDidChangeBlock = (_ value: Bool) -> Void
	public var switchDidChangeBlock: SwitchDidChangeBlock = { (value: Bool) in
		SwiftyFormLog("not overridden")
	}

	public func switchDidChange(_ value: Bool) {
		innerValue = value
		switchDidChangeBlock(value)
	}

	public func setValue(_ value: Bool, animated: Bool) {
		innerValue = value
		syncCellWithValue(value, animated)
	}
}
