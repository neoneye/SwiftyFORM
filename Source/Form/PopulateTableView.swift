// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

protocol WillPopCommandProtocol {
	func execute(context: ViewControllerFormItemPopContext)
}


class WillPopCustomViewController: WillPopCommandProtocol {
	let object: AnyObject
	init(object: AnyObject) {
		self.object = object
	}
	
	func execute(context: ViewControllerFormItemPopContext) {
		if let vc = object as? ViewControllerFormItem {
			vc.willPopViewController?(context)
			return
		}
	}
}

class WillPopOptionViewController: WillPopCommandProtocol {
	let object: ViewControllerFormItem
	init(object: ViewControllerFormItem) {
		self.object = object
	}
	
	func execute(context: ViewControllerFormItemPopContext) {
		object.willPopViewController?(context)
	}
}


struct PopulateTableViewModel {
	var viewController: UIViewController
	var toolbarMode: ToolbarMode
}



class PopulateTableView: FormItemVisitor {
	let model: PopulateTableViewModel
	
	var cells = [UITableViewCell]()
	var sections = [TableViewSection]()
	var headerBlock: TableViewSectionPart.CreateBlock?
	
	init(model: PopulateTableViewModel) {
		self.model = model
	}
	
	func closeSection(footerBlock: TableViewSectionPart.CreateBlock) {
		var headerBlock: Void -> TableViewSectionPart = {
			return TableViewSectionPart.None
		}
		if let block = self.headerBlock {
			headerBlock = block
		}
		
		let section = TableViewSection(cells: cells, headerBlock: headerBlock, footerBlock: footerBlock)
		sections.append(section)

		cells = [UITableViewCell]()
		self.headerBlock = nil
	}
	
	
	func visitMeta(object: MetaFormItem) {
		// this item is not visual
	}

	func visitCustom(object: CustomFormItem) {
		let context = CustomFormItem.Context(
			viewController: model.viewController
		)
		do {
			let cell = try object.createCell(context)
			cells.append(cell)
		} catch {
			print("ERROR: Could not create cell for custom form item: \(error)")

			var model = StaticTextCellModel()
			model.title = "CustomFormItem"
			model.value = "Exception"
			let cell = StaticTextCell(model: model)
			cells.append(cell)
		}
	}
	
	func visitStaticText(object: StaticTextFormItem) {
		var model = StaticTextCellModel()
		model.title = object.title
		model.value = object.value
		let cell = StaticTextCell(model: model)
		cells.append(cell)

		weak var weakCell = cell
		object.syncCellWithValue = { (value: String) in
			SwiftyFormLog("sync value \(value)")
			if let c = weakCell {
				var m = StaticTextCellModel()
				m.title = c.model.title
				m.value = value
				c.model = m
				c.loadWithModel(m)
			}
		}
	}
    
    func visitAttributedText(object: AttributedTextFormItem) {
        var model = AttributedTextCellModel()
        model.title = object.title
        model.value = object.value
        model.attribute = object.attribute
        let cell = AttributedTextCell(model: model)
        cells.append(cell)
        
        weak var weakCell = cell
        object.syncCellWithValue = { (value: String) in
            SwiftyFormLog("sync value \(value)")
            if let c = weakCell {
                var m = AttributedTextCellModel()
                m.title = c.model.title
                m.attribute = c.model.attribute
                m.value = value
                c.model = m
                c.loadWithModel(m)
            }
        }
    }
	
	func visitTextField(object: TextFieldFormItem) {
		var model = TextFieldFormItemCellModel()
		model.toolbarMode = self.model.toolbarMode
		model.title = object.title
		model.placeholder = object.placeholder
		model.keyboardType = object.keyboardType
		model.returnKeyType = object.returnKeyType
		model.autocorrectionType = object.autocorrectionType
		model.autocapitalizationType = object.autocapitalizationType
		model.spellCheckingType = object.spellCheckingType
		model.secureTextEntry = object.secureTextEntry
		model.model = object
		weak var weakObject = object
		model.valueDidChange = { (value: String) in
			SwiftyFormLog("value \(value)")
			weakObject?.textDidChange(value)
			return
		}
		let cell = TextFieldFormItemCell(model: model)
		cell.setValueWithoutSync(object.value)
		cells.append(cell)
		
		weak var weakCell = cell
		object.syncCellWithValue = { (value: String) in
			SwiftyFormLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value)
			return
		}
		
		object.reloadPersistentValidationState = {
			weakCell?.reloadPersistentValidationState()
			return
		}
		
		object.obtainTitleWidth = {
			if let cell = weakCell {
				let size = cell.titleLabel.intrinsicContentSize()
				return size.width
			}
			return 0
		}

		object.assignTitleWidth = { (width: CGFloat) in
			if let cell = weakCell {
				cell.titleWidthMode = TextFieldFormItemCell.TitleWidthMode.Assign(width: width)
				cell.setNeedsUpdateConstraints()
			}
		}
	}
	
	func visitTextView(object: TextViewFormItem) {
		var model = TextViewCellModel()
		model.toolbarMode = self.model.toolbarMode
		model.title = object.title
		model.placeholder = object.placeholder
		weak var weakObject = object
		model.valueDidChange = { (value: String) in
			SwiftyFormLog("value \(value)")
			weakObject?.innerValue = value
			return
		}
		let cell = TextViewCell(model: model)
		cell.setValueWithoutSync(object.value)
		cells.append(cell)

		weak var weakCell = cell
		object.syncCellWithValue = { (value: String) in
			SwiftyFormLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value)
			return
		}
	}

	func visitViewController(object: ViewControllerFormItem) {
		let model = ViewControllerFormItemCellModel(title: object.title, placeholder: object.placeholder)
		let willPopViewController = WillPopCustomViewController(object: object)
		
		weak var weakViewController = self.model.viewController
		let cell = ViewControllerFormItemCell(model: model) { (cell: ViewControllerFormItemCell, modelObject: ViewControllerFormItemCellModel) in
			SwiftyFormLog("push")
			if let vc = weakViewController {
				let dismissCommand = PopulateTableView.prepareDismissCommand(willPopViewController, parentViewController: vc, cell: cell)
				if let childViewController = object.createViewController?(dismissCommand) {
					vc.navigationController?.pushViewController(childViewController, animated: true)
				}
			}
		}
		cells.append(cell)
	}
	
	class func prepareDismissCommand(willPopCommand: WillPopCommandProtocol, parentViewController: UIViewController, cell: ViewControllerFormItemCell) -> CommandProtocol {
		weak var weakViewController = parentViewController
		let command = CommandBlock { (childViewController: UIViewController, returnObject: AnyObject?) in
			SwiftyFormLog("pop: \(returnObject)")
			if let vc = weakViewController {
				let context = ViewControllerFormItemPopContext(parentViewController: vc, childViewController: childViewController, cell: cell, returnedObject: returnObject)
				willPopCommand.execute(context)
				vc.navigationController?.popViewControllerAnimated(true)
			}
		}
		return command
	}

	func visitOptionPicker(object: OptionPickerFormItem) {
		var model = OptionViewControllerCellModel()
		model.title = object.title
		model.placeholder = object.placeholder
		model.optionField = object
		model.selectedOptionRow = object.selected

		weak var weakObject = object
		model.valueDidChange = { (value: OptionRowModel?) in
			SwiftyFormLog("propagate from cell to model. value \(value)")
			weakObject?.innerSelected = value
			weakObject?.valueDidChange(selected: value)
		}
		
		let cell = OptionViewControllerCell(
			parentViewController: self.model.viewController,
			model: model
		)
		cells.append(cell)
		
		weak var weakCell = cell
		object.syncCellWithValue = { (selected: OptionRowModel?) in
			SwiftyFormLog("propagate from model to cell. option: \(selected?.title)")
			weakCell?.setSelectedOptionRowWithoutPropagation(selected)
		}
	}
	
	func mapDatePickerMode(mode: DatePickerFormItemMode) -> UIDatePickerMode {
		switch mode {
		case .Date: return UIDatePickerMode.Date
		case .Time: return UIDatePickerMode.Time
		case .DateAndTime: return UIDatePickerMode.DateAndTime
		}
	}
	
	func visitDatePicker(object: DatePickerFormItem) {
		var model = DatePickerCellModel()
		model.title = object.title
		model.toolbarMode = self.model.toolbarMode
		model.datePickerMode = mapDatePickerMode(object.datePickerMode)
		model.locale = object.locale
		model.minimumDate = object.minimumDate
		model.maximumDate = object.maximumDate
		
		weak var weakObject = object
		model.valueDidChange = { (date: NSDate) in
			SwiftyFormLog("value did change \(date)")
			weakObject?.innerValue = date
			return
		}
		
		let cell = DatePickerCell(model: model)
		
		SwiftyFormLog("will assign date \(object.value)")
		cell.setDateWithoutSync(object.value, animated: false)
		SwiftyFormLog("did assign date \(object.value)")
		cells.append(cell)
		
		weak var weakCell = cell
		object.syncCellWithValue = { (date: NSDate?, animated: Bool) in
			SwiftyFormLog("sync date \(date)")
			weakCell?.setDateWithoutSync(date, animated: animated)
			return
		}
	}
	
	func visitButton(object: ButtonFormItem) {
		var model = ButtonCellModel()
		model.title = object.title
		model.action = object.action
		let cell = ButtonCell(model: model)
		cells.append(cell)
	}

	func visitOptionRow(object: OptionRowFormItem) {
		weak var weakViewController = self.model.viewController
		let cell = OptionCell(model: object) {
			SwiftyFormLog("did select option")
			if let vc = weakViewController {
				if let x = vc as? SelectOptionDelegate {
					x.form_willSelectOption(object)
				}
			}
		}
		cells.append(cell)
	}
	
	func visitSwitch(object: SwitchFormItem) {
		var model = SwitchCellModel()
		model.title = object.title
		
		weak var weakObject = object
		model.valueDidChange = { (value: Bool) in
			SwiftyFormLog("value did change \(value)")
			weakObject?.switchDidChange(value)
			return
		}

		let cell = SwitchCell(model: model)
		cells.append(cell)

		SwiftyFormLog("will assign value \(object.value)")
		cell.setValueWithoutSync(object.value, animated: false)
		SwiftyFormLog("did assign value \(object.value)")

		weak var weakCell = cell
		object.syncCellWithValue = { (value: Bool, animated: Bool) in
			SwiftyFormLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value, animated: animated)
			return
		}
	}
	
	func visitStepper(object: StepperFormItem) {
		var model = StepperCellModel()
		model.title = object.title
		model.value = object.value

		weak var weakObject = object
		model.valueDidChange = { (value: Int) in
			SwiftyFormLog("value \(value)")
			weakObject?.innerValue = value
			return
		}

		let cell = StepperCell(model: model)
		cells.append(cell)

		SwiftyFormLog("will assign value \(object.value)")
		cell.setValueWithoutSync(object.value, animated: true)
		SwiftyFormLog("did assign value \(object.value)")

		weak var weakCell = cell
		object.syncCellWithValue = { (value: Int, animated: Bool) in
			SwiftyFormLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value, animated: animated)
			return
		}
	}

	func visitSlider(object: SliderFormItem) {
		var model = SliderCellModel()
		model.minimumValue = object.minimumValue
		model.maximumValue = object.maximumValue
		model.value = object.value

		
		weak var weakObject = object
		model.valueDidChange = { (value: Float) in
			SwiftyFormLog("value did change \(value)")
			weakObject?.sliderDidChange(value)
			return
		}

		let cell = SliderCell(model: model)
		cells.append(cell)

		weak var weakCell = cell
		object.syncCellWithValue = { (value: Float, animated: Bool) in
			SwiftyFormLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value, animated: animated)
			return
		}
	}
	
	func visitSection(object: SectionFormItem) {
		let footerBlock: TableViewSectionPart.CreateBlock = {
			return TableViewSectionPart.None
		}
		closeSection(footerBlock)
	}

	func visitSectionHeaderTitle(object: SectionHeaderTitleFormItem) {
		if cells.count > 0 || self.headerBlock != nil {
			let footerBlock: TableViewSectionPart.CreateBlock = {
				return TableViewSectionPart.None
			}
			closeSection(footerBlock)
		}

		self.headerBlock = {
			var item = TableViewSectionPart.None
			if let title = object.title {
				item = TableViewSectionPart.TitleString(string: title)
			}
			return item
		}
	}
	
	func visitSectionHeaderView(object: SectionHeaderViewFormItem) {
		if cells.count > 0 || self.headerBlock != nil {
			let footerBlock: TableViewSectionPart.CreateBlock = {
				return TableViewSectionPart.None
			}
			closeSection(footerBlock)
		}

		self.headerBlock = {
			let view: UIView? = object.viewBlock?()
			var item = TableViewSectionPart.None
			if let view = view {
				item = TableViewSectionPart.TitleView(view: view)
			}
			return item
		}
	}

	func visitSectionFooterTitle(object: SectionFooterTitleFormItem) {
		let footerBlock: TableViewSectionPart.CreateBlock = {
			var footer = TableViewSectionPart.None
			if let title = object.title {
				footer = TableViewSectionPart.TitleString(string: title)
			}
			return footer
		}
		closeSection(footerBlock)
	}
	
	func visitSectionFooterView(object: SectionFooterViewFormItem) {
		let footerBlock: TableViewSectionPart.CreateBlock = {
			let view: UIView? = object.viewBlock?()
			var item = TableViewSectionPart.None
			if let view = view {
				item = TableViewSectionPart.TitleView(view: view)
			}
			return item
		}
		closeSection(footerBlock)
	}
	
	func visitSegmentedControl(object: SegmentedControlFormItem) {
		var model = SegmentedControlCellModel()
		model.title = object.title
		model.items = object.items
		model.value = object.selected
		
		weak var weakObject = object
		model.valueDidChange = { (value: Int) in
			SwiftyFormLog("value did change \(value)")
			weakObject?.valueDidChange(value)
			return
		}
		
		let cell = SegmentedControlCell(model: model)
		cells.append(cell)
		
		weak var weakCell = cell
		object.syncCellWithValue = { (value: Int) in
			SwiftyFormLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value)
			return
		}
	}
}
