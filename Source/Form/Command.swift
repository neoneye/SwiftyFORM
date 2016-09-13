// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public protocol CommandProtocol {
	func execute(_ viewController: UIViewController, returnObject: AnyObject?)
}

open class CommandBlock: CommandProtocol {
	open let block: (UIViewController, AnyObject?) -> Void
	public init(block: @escaping (UIViewController, AnyObject?) -> Void) {
		self.block = block
	}
	
	open func execute(_ viewController: UIViewController, returnObject: AnyObject?) {
		block(viewController, returnObject)
	}
}
