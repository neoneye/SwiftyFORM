// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public class AttributedTextFormItem: FormItem {
    override func accept(visitor: FormItemVisitor) {
        visitor.visitAttributedText(self)
    }
    
	public var title: NSAttributedString?
	public func title(title: NSAttributedString) -> Self {
		self.title = title
		return self
	}
	public func title(title: String, _ attributes: [String: AnyObject]? = nil) -> Self {
		self.title = NSAttributedString(string: title, attributes: attributes)
		return self
	}
	
	
	typealias SyncBlock = (value: NSAttributedString?) -> Void
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
			syncCellWithValue(value: innerValue)
		}
	}
	public func value(value: NSAttributedString) -> Self {
		self.value = value
		return self
	}
	public func value(value: String, _ attributes: [String: AnyObject]? = nil) -> Self {
		self.value = NSAttributedString(string: value, attributes: attributes)
		return self
	}
}
