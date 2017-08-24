// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

class AlignLeft {
	fileprivate let items: [FormItem]
	init(items: [FormItem]) {
		self.items = items
	}
}

public enum ToolbarMode {
	case none
	case simple
}

public class FormBuilder {
	private var innerItems = [FormItem]()
	private var alignLeftItems = [AlignLeft]()

	public init() {
	}

	public var navigationTitle: String?

	public var toolbarMode: ToolbarMode = .none

	public var suppressHeaderForFirstSection = false

	public func removeAll() {
		innerItems.removeAll()
	}

	@discardableResult
	public func append(_ item: FormItem) -> FormItem {
		innerItems.append(item)
		return item
	}

	public func appendMulti(_ items: [FormItem]) {
		innerItems += items
	}

	public func alignLeft(_ items: [FormItem]) {
		let alignLeftItem = AlignLeft(items: items)
		alignLeftItems.append(alignLeftItem)
	}

	public func alignLeftElementsWithClass(_ styleClass: String) {
		let items: [FormItem] = innerItems.filter { $0.styleClass == styleClass }
		alignLeft(items)
	}

	public var items: [FormItem] {
		return innerItems
	}

	public func dump(_ prettyPrinted: Bool = true) -> Data {
		return DumpVisitor.dump(prettyPrinted, items: innerItems)
	}

	public func result(_ viewController: UIViewController) -> TableViewSectionArray {
		let model = PopulateTableViewModel(viewController: viewController, toolbarMode: toolbarMode)

		let v = PopulateTableView(model: model)
		if suppressHeaderForFirstSection {
			v.installZeroHeightHeader()
		}
		for item in innerItems {
			item.accept(visitor: v)
		}
		v.closeLastSection()

		for alignLeftItem in alignLeftItems {
			let widthArray: [CGFloat] = alignLeftItem.items.map {
				let v = ObtainTitleWidth()
				$0.accept(visitor: v)
				return v.width
			}
			//SwiftyFormLog("widthArray: \(widthArray)")
			let width = widthArray.max()!
			//SwiftyFormLog("max width: \(width)")

			for item in alignLeftItem.items {
				let v = AssignTitleWidth(width: width)
				item.accept(visitor: v)
			}
		}

		return TableViewSectionArray(sections: v.sections)
	}

	public func validateAndUpdateUI() {
		ReloadPersistentValidationStateVisitor.validateAndUpdateUI(innerItems)
	}

	public enum FormValidateResult {
		case valid
		case invalid(item: FormItem, message: String)
	}

	public func validate() -> FormValidateResult {
		for item in innerItems {
			let v = ValidateVisitor()
			item.accept(visitor: v)
			switch v.result {
			case .valid:
				// SwiftyFormLog("valid")
				continue
			case .hardInvalid(let message):
				//SwiftyFormLog("invalid message \(message)")
				return .invalid(item: item, message: message)
			case .softInvalid(let message):
				//SwiftyFormLog("invalid message \(message)")
				return .invalid(item: item, message: message)
			}
		}
		return .valid
	}

}

public func += (left: FormBuilder, right: FormItem) {
	left.append(right)
}
