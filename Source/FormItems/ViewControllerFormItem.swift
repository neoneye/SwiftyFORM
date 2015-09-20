// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import Foundation

public class ViewControllerFormItemPopContext {
	public let parentViewController: UIViewController
	public let childViewController: UIViewController
	public let cell: ViewControllerFormItemCell
	public let returnedObject: AnyObject?
	
	public init(parentViewController: UIViewController, childViewController: UIViewController, cell: ViewControllerFormItemCell, returnedObject: AnyObject?) {
		self.parentViewController = parentViewController
		self.childViewController = childViewController
		self.cell = cell
		self.returnedObject = returnedObject
	}
}

public class ViewControllerFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitViewController(self)
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
	
	public func viewController(aClass: UIViewController.Type) -> Self {
		createViewController = { (dismissCommand: CommandProtocol) in
			return aClass.init()
		}
		return self
	}
	
	public func storyboard(name: String, bundle storyboardBundleOrNil: NSBundle?) -> Self {
		createViewController = { (dismissCommand: CommandProtocol) in
			let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: storyboardBundleOrNil)
			return storyboard.instantiateInitialViewController()
		}
		return self
	}
	
	// the view controller must invoke the dismiss block when it's being dismissed
	public typealias CreateViewController = CommandProtocol -> UIViewController?
	public var createViewController: CreateViewController?
	
	// dismissing the view controller
	public typealias PopViewController = ViewControllerFormItemPopContext -> Void
	public var willPopViewController: PopViewController?
}
