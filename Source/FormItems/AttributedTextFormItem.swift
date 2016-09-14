// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public class AttributedTextFormItem: FormItem {
    override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
    }
    
	public var title: NSAttributedString?

	@discardableResult
	public func title(_ title: NSAttributedString) -> Self {
		self.title = title
		return self
	}

	@discardableResult
	public func title(_ title: String, _ attributes: [String: AnyObject]? = nil) -> Self {
		self.title = NSAttributedString(string: title, attributes: attributes)
		return self
	}
	
	
	typealias SyncBlock = (_ value: NSAttributedString?) -> Void
	var syncCellWithValue: SyncBlock = { (value: NSAttributedString?) in
		SwiftyFormLog("sync is not overridden")
	}
	
	internal var innerValue: NSAttributedString?
	public var value: NSAttributedString? {
		get {
			return self.innerValue
		}
		set {
			innerValue = newValue
			syncCellWithValue(innerValue)
		}
	}

	@discardableResult
	public func value(_ value: NSAttributedString) -> Self {
		self.value = value
		return self
	}

	@discardableResult
	public func value(_ value: String, _ attributes: [String: AnyObject]? = nil) -> Self {
		self.value = NSAttributedString(string: value, attributes: attributes)
		return self
	}
}
