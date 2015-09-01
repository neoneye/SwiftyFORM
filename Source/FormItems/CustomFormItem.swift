//  Copyright © 2015 Simon Strandgaard. All rights reserved.
import Foundation

public class CustomFormItem: FormItem {
	enum CustomFormItemError: ErrorType {
		case CouldNotCreate
	}

	typealias CreateCell = Void throws -> UITableViewCell
	var createCell: CreateCell = { throw CustomFormItemError.CouldNotCreate }
	
	override func accept(visitor: FormItemVisitor) {
		visitor.visitCustom(self)
	}
}
