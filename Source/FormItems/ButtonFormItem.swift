// MIT license. Copyright (c) 2018 SwiftyFORM. All rights reserved.
import UIKit

public class ButtonFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""
    
    @discardableResult
    public func title(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    public var textColor: UIColor = Colors.text
    
    @discardableResult
    public func textColor(_ textColor: UIFont) -> Self {
        self.textColor = textColor
        return self
    }
    
    public var font: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    public var textAlignment: NSTextAlignment = .center

	public var action: () -> Void = {}
    
}
