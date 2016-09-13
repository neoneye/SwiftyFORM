// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class ViewControllerFormItemPopContext {
	open let parentViewController: UIViewController
	open let childViewController: UIViewController
	open let cell: ViewControllerFormItemCell
	open let returnedObject: AnyObject?
	
	public init(parentViewController: UIViewController, childViewController: UIViewController, cell: ViewControllerFormItemCell, returnedObject: AnyObject?) {
		self.parentViewController = parentViewController
		self.childViewController = childViewController
		self.cell = cell
		self.returnedObject = returnedObject
	}
}

open class ViewControllerFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var placeholder: String = ""
	open func placeholder(_ placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}
	
	open var title: String = ""
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
	
	open func viewController(_ aClass: UIViewController.Type) -> Self {
		createViewController = { (dismissCommand: CommandProtocol) in
			return aClass.init()
		}
		return self
	}
	
	open func storyboard(_ name: String, bundle storyboardBundleOrNil: Bundle?) -> Self {
		createViewController = { (dismissCommand: CommandProtocol) in
			let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: storyboardBundleOrNil)
			return storyboard.instantiateInitialViewController()
		}
		return self
	}
	
	// the view controller must invoke the dismiss block when it's being dismissed
	public typealias CreateViewController = (CommandProtocol) -> UIViewController?
	open var createViewController: CreateViewController?
	
	// dismissing the view controller
	public typealias PopViewController = (ViewControllerFormItemPopContext) -> Void
	open var willPopViewController: PopViewController?
}
