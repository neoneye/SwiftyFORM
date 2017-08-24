// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
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

	@discardableResult
	public func viewController(_ aClass: UIViewController.Type) -> Self {
		createViewController = { (dismissCommand: CommandProtocol) in
			return aClass.init()
		}
		return self
	}

	@discardableResult
	public func storyboard(_ name: String, bundle storyboardBundleOrNil: Bundle?) -> Self {
		createViewController = { (dismissCommand: CommandProtocol) in
			let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: storyboardBundleOrNil)
			return storyboard.instantiateInitialViewController()
		}
		return self
	}

	// the view controller must invoke the dismiss block when it's being dismissed
	public typealias CreateViewController = (CommandProtocol) -> UIViewController?
	public var createViewController: CreateViewController?

	// dismissing the view controller
	public typealias PopViewController = (ViewControllerFormItemPopContext) -> Void
	public var willPopViewController: PopViewController?
}
