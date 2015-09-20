// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public protocol CommandProtocol {
	func execute(viewController: UIViewController, returnObject: AnyObject?)
}

public class CommandBlock: CommandProtocol {
	public let block: (UIViewController, AnyObject?) -> Void
	public init(block: (UIViewController, AnyObject?) -> Void) {
		self.block = block
	}
	
	public func execute(viewController: UIViewController, returnObject: AnyObject?) {
		block(viewController, returnObject)
	}
}