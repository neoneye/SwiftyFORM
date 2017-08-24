// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

public class CustomFormItem: FormItem {
	public struct Context {
		public let viewController: UIViewController
	}

	public enum CustomFormItemError: Error {
		case couldNotCreate
	}

	public typealias CreateCell = (Context) throws -> UITableViewCell
	public var createCell: CreateCell = { _ in throw CustomFormItemError.couldNotCreate }

	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}
}
