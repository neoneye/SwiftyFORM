// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import Foundation

extension NSBundle {
	public enum FormLoadViewError: ErrorType {
		case ExpectedXibToExistButGotNil
		case ExpectedXibToContainJustOneButGotDifferentNumberOfObjects
		case XibReturnedWrongType
	}
	
	/* 
	usage:
	let cell: ContactPickerCell = try NSBundle.mainBundle().form_loadView("ContactPickerCell")
	*/
	public func form_loadView<T>(name: String) throws -> T {
		let topLevelObjects: [AnyObject]! = loadNibNamed(name, owner: self, options: nil)
		if topLevelObjects == nil {
			throw FormLoadViewError.ExpectedXibToExistButGotNil
		}
		if topLevelObjects.count != 1 {
			throw FormLoadViewError.ExpectedXibToContainJustOneButGotDifferentNumberOfObjects
		}
		let firstObject: AnyObject! = topLevelObjects.first
		guard let result = firstObject as? T else {
			throw FormLoadViewError.XibReturnedWrongType
		}
		return result
	}
}
