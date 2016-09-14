// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
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


open class FormBuilder: NSObject {
	fileprivate var innerItems = [FormItem]()
	fileprivate var alignLeftItems = [AlignLeft]()
	
	override public init() {
		super.init()
	}
	
	open var navigationTitle: String? = nil
	
	open var toolbarMode: ToolbarMode = .none
	
	open func removeAll() {
		innerItems.removeAll()
	}
	
	open func append(_ item: FormItem) -> FormItem {
		innerItems.append(item)
		return item
	}
	
	open func appendMulti(_ items: [FormItem]) {
		innerItems += items
	}
	
	open func alignLeft(_ items: [FormItem]) {
		let alignLeftItem = AlignLeft(items: items)
		alignLeftItems.append(alignLeftItem)
	}
	
	open func alignLeftElementsWithClass(_ styleClass: String) {
		let items: [FormItem] = innerItems.filter { $0.styleClass == styleClass }
		alignLeft(items)
	}
	
	open var items: [FormItem] {
		return innerItems
	}
	
	open func dump(_ prettyPrinted: Bool = true) -> Data {
		return DumpVisitor.dump(prettyPrinted, items: innerItems)
	}
	
	open func result(_ viewController: UIViewController) -> TableViewSectionArray {
		let model = PopulateTableViewModel(viewController: viewController, toolbarMode: toolbarMode)
		
		let v = PopulateTableView(model: model)
		for item in innerItems {
			item.accept(visitor: v)
		}
		let footerBlock: TableViewSectionPart.CreateBlock = {
			return TableViewSectionPart.none
		}
		v.closeSection(footerBlock)
		
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
	
	open func validateAndUpdateUI() {
		ReloadPersistentValidationStateVisitor.validateAndUpdateUI(innerItems)
	}
	
	public enum FormValidateResult {
		case valid
		case invalid(item: FormItem, message: String)
	}
	
	open func validate() -> FormValidateResult {
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

