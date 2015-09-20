// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import Foundation

@objc public protocol SelectOptionDelegate {
	func form_willSelectOption(option: OptionRowFormItem)
}