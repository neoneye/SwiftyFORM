// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import Foundation

extension Bundle {
	public enum FormLoadViewError: Error {
		case expectedXibToExistButGotNil
		case expectedXibToContainJustOneButGotDifferentNumberOfObjects
		case xibReturnedWrongType
	}

	/* 
	usage:
	let cell: ContactPickerCell = try Bundle.main.form_loadView("ContactPickerCell")
	*/
	public func form_loadView<T>(_ name: String) throws -> T {
		guard let topLevelObjects = loadNibNamed(name, owner: self, options: nil) else {
			throw FormLoadViewError.expectedXibToExistButGotNil
		}
		guard topLevelObjects.count == 1 else {
			throw FormLoadViewError.expectedXibToContainJustOneButGotDifferentNumberOfObjects
		}
		guard let result = topLevelObjects.first as? T else {
			throw FormLoadViewError.xibReturnedWrongType
		}
		return result
	}
}
