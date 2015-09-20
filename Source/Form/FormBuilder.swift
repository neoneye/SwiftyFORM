// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

class AlignLeft {
	private let items: [FormItem]
	init(items: [FormItem]) {
		self.items = items
	}
}

public enum ToolbarMode {
	case None
	case Simple
}


public class FormBuilder: NSObject {
	private var innerItems = [FormItem]()
	private var alignLeftItems = [AlignLeft]()
	
	override public init() {
		super.init()
	}
	
	public var navigationTitle: String? = nil
	
	public var toolbarMode: ToolbarMode = .None
	
	public func removeAll() {
		innerItems.removeAll()
	}
	
	public func append(item: FormItem) -> FormItem {
		innerItems.append(item)
		return item
	}
	
	public func appendMulti(items: [FormItem]) {
		innerItems += items
	}
	
	public func alignLeft(items: [FormItem]) {
		let alignLeftItem = AlignLeft(items: items)
		alignLeftItems.append(alignLeftItem)
	}
	
	public func alignLeftElementsWithClass(styleClass: String) {
		let items: [FormItem] = innerItems.filter { $0.styleClass == styleClass }
		alignLeft(items)
	}
	
	public var items: [FormItem] {
		return innerItems
	}
	
	public func dump(prettyPrinted: Bool = true) -> NSData {
		return DumpVisitor.dump(prettyPrinted, items: innerItems)
	}
	
	func result(viewController: UIViewController) -> TableViewSectionArray {
		let model = PopulateTableViewModel(viewController: viewController, toolbarMode: toolbarMode)
		
		let v = PopulateTableView(model: model)
		for item in innerItems {
			item.accept(v)
		}
		let footerBlock: TableViewSectionPart.CreateBlock = {
			return TableViewSectionPart.None
		}
		v.closeSection(footerBlock)
		
		for alignLeftItem in alignLeftItems {
			let widthArray: [CGFloat] = alignLeftItem.items.map {
				let v = ObtainTitleWidth()
				$0.accept(v)
				return v.width
			}
			//DLog("widthArray: \(widthArray)")
			let width = widthArray.maxElement()!
			//DLog("max width: \(width)")
			
			for item in alignLeftItem.items {
				let v = AssignTitleWidth(width: width)
				item.accept(v)
			}
		}
		
		return TableViewSectionArray(sections: v.sections)
	}
	
	public func validateAndUpdateUI() {
		ReloadPersistentValidationStateVisitor.validateAndUpdateUI(innerItems)
	}
	
	public enum FormValidateResult {
		case Valid
		case Invalid(item: FormItem, message: String)
	}
	
	public func validate() -> FormValidateResult {
		for item in innerItems {
			let v = ValidateVisitor()
			item.accept(v)
			switch v.result {
			case .Valid:
				// DLog("valid")
				continue
			case .HardInvalid(let message):
				//DLog("invalid message \(message)")
				return .Invalid(item: item, message: message)
			case .SoftInvalid(let message):
				//DLog("invalid message \(message)")
				return .Invalid(item: item, message: message)
			}
		}
		return .Valid
	}
	
}

public func += (left: FormBuilder, right: FormItem) {
	left.append(right)
}

