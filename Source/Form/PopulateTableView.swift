// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

protocol WillPopCommandProtocol {
	func execute(_ context: ViewControllerFormItemPopContext)
}


class WillPopCustomViewController: WillPopCommandProtocol {
	let object: AnyObject
	init(object: AnyObject) {
		self.object = object
	}
	
	func execute(_ context: ViewControllerFormItemPopContext) {
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
	
	func execute(_ context: ViewControllerFormItemPopContext) {
		object.willPopViewController?(context)
	}
}


struct PopulateTableViewModel {
	var viewController: UIViewController
	var toolbarMode: ToolbarMode
}



class PopulateTableView: FormItemVisitor {
	let model: PopulateTableViewModel
	
	var cells: TableViewCellArray = TableViewCellArray.createEmpty()
	var sections = [TableViewSection]()
	var headerBlock: TableViewSectionPart.CreateBlock?
	
	init(model: PopulateTableViewModel) {
		self.model = model
	}
	
	func closeSection(_ footerBlock: TableViewSectionPart.CreateBlock) {
		var headerBlock: (Void) -> TableViewSectionPart = {
			return TableViewSectionPart.none
		}
		if let block = self.headerBlock {
			headerBlock = block
		}
		
		cells.reloadVisibleItems()
		let section = TableViewSection(cells: cells, headerBlock: headerBlock, footerBlock: footerBlock)
		sections.append(section)

		cells = TableViewCellArray.createEmpty()
		self.headerBlock = nil
	}
	
	
	// MARK: AttributedTextFormItem
	
	func visit(_ object: AttributedTextFormItem) {
		var model = AttributedTextCellModel()
		model.titleAttributedText = object.title
		model.valueAttributedText = object.value
		let cell = AttributedTextCell(model: model)
		cells.append(cell)
		
		weak var weakCell = cell
		object.syncCellWithValue = { (value: NSAttributedString?) in
			SwiftyFormLog("sync value \(value)")
			if let c = weakCell {
				var m = AttributedTextCellModel()
				m.titleAttributedText = c.model.titleAttributedText
				m.valueAttributedText = value
				c.model = m
				c.loadWithModel(m)
			}
		}
	}

	
	// MARK: ButtonFormItem
	
	func visit(_ object: ButtonFormItem) {
		var model = ButtonCellModel()
		model.title = object.title
		model.action = object.action
		let cell = ButtonCell(model: model)
		cells.append(cell)
	}
	

	// MARK: CustomFormItem
	
	func visit(_ object: CustomFormItem) {
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
	
	
	// MARK: DatePickerFormItem
	
	func visit(_ object: DatePickerFormItem) {
		let model = DatePickerCellModel()
		model.title = object.title
		model.datePickerMode = mapDatePickerMode(object.datePickerMode)
		model.locale = object.locale
		model.minimumDate = object.minimumDate
		model.maximumDate = object.maximumDate
		model.date = object.value
		
		switch object.behavior {
		case .collapsed, .expanded:
			model.expandCollapseWhenSelectingRow = true
			model.selectionStyle = .default
		case .expandedAlways:
			model.expandCollapseWhenSelectingRow = false
			model.selectionStyle = .none
		}
		
		let cell = DatePickerToggleCell(model: model)
		let cellExpanded = DatePickerExpandedCell()
		
		cells.append(cell)
		switch object.behavior {
		case .collapsed:
			cells.appendHidden(cellExpanded)
		case .expanded, .expandedAlways:
			cells.append(cellExpanded)
		}
		
		cellExpanded.collapsedCell = cell
		cell.expandedCell = cellExpanded

		cellExpanded.configure(model)
		
		weak var weakCell = cell
		object.syncCellWithValue = { (date: Date, animated: Bool) in
			SwiftyFormLog("sync date \(date)")
			weakCell?.setDateWithoutSync(date, animated: animated)
		}

		weak var weakObject = object
		model.valueDidChange = { (date: Date) in
			SwiftyFormLog("value did change \(date)")
			weakObject?.valueDidChange(date)
		}
	}
	
	func mapDatePickerMode(_ mode: DatePickerFormItemMode) -> UIDatePickerMode {
		switch mode {
		case .date: return UIDatePickerMode.date
		case .time: return UIDatePickerMode.time
		case .dateAndTime: return UIDatePickerMode.dateAndTime
		}
	}
	
	
	// MARK: MetaFormItem
	
	func visit(_ object: MetaFormItem) {
		// this item is not visual
	}
	
	
	// MARK: OptionPickerFormItem
	
	func visit(_ object: OptionPickerFormItem) {
		var model = OptionViewControllerCellModel()
		model.title = object.title
		model.placeholder = object.placeholder
		model.optionField = object
		model.selectedOptionRow = object.selected

		weak var weakObject = object
		model.valueDidChange = { (value: OptionRowModel?) in
			SwiftyFormLog("propagate from cell to model. value \(value)")
			weakObject?.innerSelected = value
			weakObject?.valueDidChange(value)
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
	
	
	// MARK: OptionRowFormItem
	
	func visit(_ object: OptionRowFormItem) {
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
	
	
	// MARK: PrecisionSliderFormItem
	
	func visit(_ object: PrecisionSliderFormItem) {
		let model = PrecisionSliderCellModel()
		model.decimalPlaces = object.decimalPlaces
		model.minimumValue = object.minimumValue
		model.maximumValue = object.maximumValue
		model.value = object.value
		model.title = object.title
		model.initialZoom = object.initialZoom
		model.zoomUI = object.zoomUI
		model.collapseWhenResigning = object.collapseWhenResigning
		
		switch object.behavior {
		case .collapsed, .expanded:
			model.expandCollapseWhenSelectingRow = true
			model.selectionStyle = .default
		case .expandedAlways:
			model.expandCollapseWhenSelectingRow = false
			model.selectionStyle = .none
		}
		
		let cell = PrecisionSliderToggleCell(model: model)
		let cellExpanded = PrecisionSliderExpandedCell()

		cells.append(cell)
		switch object.behavior {
		case .collapsed:
			cells.appendHidden(cellExpanded)
		case .expanded, .expandedAlways:
			cells.append(cellExpanded)
		}
		
		cellExpanded.collapsedCell = cell
		cell.expandedCell = cellExpanded
		
		weak var weakObject = object
		model.valueDidChange = { (changeModel: PrecisionSliderCellModel.SliderDidChangeModel) in
			SwiftyFormLog("value did change \(changeModel.value)")
			let model = PrecisionSliderFormItem.SliderDidChangeModel(
				value: changeModel.value,
				valueUpdated: changeModel.valueUpdated,
				zoom: changeModel.zoom,
				zoomUpdated: changeModel.zoomUpdated
			)
			weakObject?.sliderDidChange(model)
		}
		
		weak var weakCell = cell
		weak var weakCellExpanded = cellExpanded
		object.syncCellWithValue = { (value: Int) in
			SwiftyFormLog("sync value \(value)")
			if let model = weakCell?.model {
				model.value = value
			}
			weakCell?.reloadValueLabel()
			weakCellExpanded?.setValueWithoutSync(value)
		}
	}
	
	
	// MARK: SectionFooterTitleFormItem
	
	func visit(_ object: SectionFooterTitleFormItem) {
		let footerBlock: TableViewSectionPart.CreateBlock = {
			var footer = TableViewSectionPart.none
			if let title = object.title {
				footer = TableViewSectionPart.titleString(string: title)
			}
			return footer
		}
		closeSection(footerBlock)
	}
	
	
	// MARK: SectionFooterViewFormItem
	
	func visit(_ object: SectionFooterViewFormItem) {
		let footerBlock: TableViewSectionPart.CreateBlock = {
			let view: UIView? = object.viewBlock?()
			var item = TableViewSectionPart.none
			if let view = view {
				item = TableViewSectionPart.titleView(view: view)
			}
			return item
		}
		closeSection(footerBlock)
	}
	
	
	// MARK: SectionFormItem
	
	func visit(_ object: SectionFormItem) {
		let footerBlock: TableViewSectionPart.CreateBlock = {
			return TableViewSectionPart.none
		}
		closeSection(footerBlock)
	}
	
	
	// MARK: SectionHeaderTitleFormItem
	
	func visit(_ object: SectionHeaderTitleFormItem) {
		if cells.count > 0 || self.headerBlock != nil {
			let footerBlock: TableViewSectionPart.CreateBlock = {
				return TableViewSectionPart.none
			}
			closeSection(footerBlock)
		}

		self.headerBlock = {
			var item = TableViewSectionPart.none
			if let title = object.title {
				item = TableViewSectionPart.titleString(string: title)
			}
			return item
		}
	}
	
	
	// MARK: SectionHeaderViewFormItem
	
	func visit(_ object: SectionHeaderViewFormItem) {
		if cells.count > 0 || self.headerBlock != nil {
			let footerBlock: TableViewSectionPart.CreateBlock = {
				return TableViewSectionPart.none
			}
			closeSection(footerBlock)
		}

		self.headerBlock = {
			let view: UIView? = object.viewBlock?()
			var item = TableViewSectionPart.none
			if let view = view {
				item = TableViewSectionPart.titleView(view: view)
			}
			return item
		}
	}
	
	
	// MARK: SegmentedControlFormItem
	
	func visit(_ object: SegmentedControlFormItem) {
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
	
	
	// MARK: SliderFormItem
	
	func visit(_ object: SliderFormItem) {
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
	
	
	// MARK: StaticTextFormItem
	
	func visit(_ object: StaticTextFormItem) {
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
	
	
	// MARK: StepperFormItem
	
	func visit(_ object: StepperFormItem) {
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
	
	
	// MARK: SwitchFormItem
	
	func visit(_ object: SwitchFormItem) {
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
	
	
	// MARK: TextFieldFormItem
	
	func visit(_ object: TextFieldFormItem) {
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
				let size = cell.titleLabel.intrinsicContentSize
				return size.width
			}
			return 0
		}
		
		object.assignTitleWidth = { (width: CGFloat) in
			if let cell = weakCell {
				cell.titleWidthMode = TextFieldFormItemCell.TitleWidthMode.assign(width: width)
				cell.setNeedsUpdateConstraints()
			}
		}
	}
	
	
	// MARK: TextViewFormItem
	
	func visit(_ object: TextViewFormItem) {
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
	
	
	// MARK: ViewControllerFormItem
	
	func visit(_ object: ViewControllerFormItem) {
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
	
	class func prepareDismissCommand(_ willPopCommand: WillPopCommandProtocol, parentViewController: UIViewController, cell: ViewControllerFormItemCell) -> CommandProtocol {
		weak var weakViewController = parentViewController
		let command = CommandBlock { (childViewController: UIViewController, returnObject: AnyObject?) in
			SwiftyFormLog("pop: \(returnObject)")
			if let vc = weakViewController {
				let context = ViewControllerFormItemPopContext(parentViewController: vc, childViewController: childViewController, cell: cell, returnedObject: returnObject)
				willPopCommand.execute(context)
				vc.navigationController?.popViewController(animated: true)
			}
		}
		return command
	}

	
	// MARK: PickerViewFormItem
	
	func visit(_ object: PickerViewFormItem) {
		let model = PickerViewCellModel()
		model.title = object.title
		model.value = object.value
		model.titles = object.pickerTitles
		model.humanReadableValueSeparator = object.humanReadableValueSeparator
		
		switch object.behavior {
		case .collapsed, .expanded:
			model.expandCollapseWhenSelectingRow = true
			model.selectionStyle = .default
		case .expandedAlways:
			model.expandCollapseWhenSelectingRow = false
			model.selectionStyle = .none
		}
		
		let cell = PickerViewToggleCell(model: model)
		let cellExpanded = PickerViewExpandedCell()
		
		cells.append(cell)
		switch object.behavior {
		case .collapsed:
			cells.appendHidden(cellExpanded)
		case .expanded, .expandedAlways:
			cells.append(cellExpanded)
		}
		
		cellExpanded.collapsedCell = cell
		cell.expandedCell = cellExpanded
		
		cellExpanded.configure(model)
		
		weak var weakCell = cell
		object.syncCellWithValue = { (value: [Int], animated: Bool) in
			SwiftyFormLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value, animated: animated)
		}
		
		weak var weakObject = object
		model.valueDidChange = { (selectedRows: [Int]) in
			SwiftyFormLog("value did change \(selectedRows)")
			weakObject?.valueDidChange(selectedRows)
		}
	}
}
