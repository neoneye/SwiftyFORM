// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
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
	var header = TableViewSectionPart.systemDefault
	var footer = TableViewSectionPart.systemDefault

	enum LastItemType {
		case beginning
		case header
		case sectionEnd
		case item
	}
	var lastItemType = LastItemType.beginning

	init(model: PopulateTableViewModel) {
		self.model = model
	}

	func installZeroHeightHeader() {
		header = .none
		lastItemType = .sectionEnd
	}

	func closeSection() {
		cells.reloadVisibleItems()
		let section = TableViewSection(cells: cells, header: header, footer: footer)
		sections.append(section)

		cells = TableViewCellArray.createEmpty()
		header = TableViewSectionPart.systemDefault
		footer = TableViewSectionPart.systemDefault
	}

	func closeLastSection() {
		switch lastItemType {
		case .beginning:
			break
		case .sectionEnd:
			break
		case .header:
			closeSection()
		case .item:
			closeSection()
		}
		lastItemType = .sectionEnd
	}

	// MARK: AttributedTextFormItem

	func visit(object: AttributedTextFormItem) {
		var model = AttributedTextCellModel()
		model.titleAttributedText = object.title
		model.valueAttributedText = object.value
		let cell = AttributedTextCell(model: model)
		cells.append(cell)
		lastItemType = .item

		object.syncCellWithValue = { [weak cell] (value: NSAttributedString?) in
			SwiftyFormLog("sync value \(String(describing: value))")
			guard let cell = cell else { return }
			var model = AttributedTextCellModel()
			model.titleAttributedText = cell.model.titleAttributedText
			model.valueAttributedText = value
			cell.model = model
			cell.loadWithModel(model)
		}
	}

	// MARK: ButtonFormItem

	func visit(object: ButtonFormItem) {
		var model = ButtonCellModel()
		model.title = object.title
		model.action = object.action
        model.textAlignment = object.textAlignment
        model.titleFont = object.titleFont
        model.titleTextColor = object.titleTextColor
        model.backgroundColor = object.backgroundColor
		let cell = ButtonCell(model: model)
		cells.append(cell)
		lastItemType = .item
	}

	// MARK: CustomFormItem

	func visit(object: CustomFormItem) {
		let context = CustomFormItem.Context(
			viewController: model.viewController
		)
		do {
			let cell = try object.createCell(context)
			cells.append(cell)
			lastItemType = .item
		} catch {
			print("ERROR: Could not create cell for custom form item: \(error)")

			var model = StaticTextCellModel()
			model.title = "CustomFormItem"
			model.value = "Exception"
			let cell = StaticTextCell(model: model)
			cells.append(cell)
			lastItemType = .item
		}
	}

	// MARK: DatePickerFormItem

	func visit(object: DatePickerFormItem) {
		let model = DatePickerCellModel()
		model.title = object.title
		model.datePickerMode = mapDatePickerMode(object.datePickerMode)
		model.locale = object.locale
		model.minimumDate = object.minimumDate
		model.maximumDate = object.maximumDate
		model.minuteInterval = object.minuteInterval
		model.date = object.value
        model.titleFont = object.titleFont
        model.titleTextColor = object.titleTextColor
        model.detailFont = object.detailFont
        model.detailTextColor = object.detailTextColor

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
		lastItemType = .item

		cellExpanded.collapsedCell = cell
		cell.expandedCell = cellExpanded

		cellExpanded.configure(model)

		object.syncCellWithValue = { [weak cell] (date: Date, animated: Bool) in
			SwiftyFormLog("sync date \(date)")
			cell?.setDateWithoutSync(date, animated: animated)
		}

		model.valueDidChange = { [weak object] (date: Date) in
			SwiftyFormLog("value did change \(date)")
			object?.valueDidChange(date)
		}
	}

	func mapDatePickerMode(_ mode: DatePickerFormItemMode) -> UIDatePicker.Mode {
		switch mode {
		case .date: return UIDatePicker.Mode.date
		case .time: return UIDatePicker.Mode.time
		case .dateAndTime: return UIDatePicker.Mode.dateAndTime
		}
	}

	// MARK: MetaFormItem

	func visit(object: MetaFormItem) {
		// this item is not visual
	}

	// MARK: OptionPickerFormItem

	func visit(object: OptionPickerFormItem) {
		var model = OptionViewControllerCellModel()
		model.title = object.title
		model.placeholder = object.placeholder
		model.optionField = object
		model.selectedOptionRow = object.selected
        model.titleFont = object.titleFont
        model.titleTextColor = object.titleTextColor
        model.detailFont = object.detailFont
        model.detailTextColor = object.detailTextColor

		model.valueDidChange = { [weak object] (value: OptionRowModel?) in
			SwiftyFormLog("propagate from cell to model. value \(String(describing: value))")
			object?.innerSelected = value
			object?.valueDidChange(value)
		}

		let cell = OptionViewControllerCell(
			parentViewController: self.model.viewController,
			model: model
		)
		cells.append(cell)
		lastItemType = .item

		object.syncCellWithValue = { [weak cell] (selected: OptionRowModel?) in
			SwiftyFormLog("propagate from model to cell. option: \(String(describing: selected?.title))")
			cell?.setSelectedOptionRowWithoutPropagation(selected)
		}
	}

	// MARK: OptionRowFormItem

	func visit(object: OptionRowFormItem) {
		let weakViewController = self.model.viewController
		let cell = OptionCell(model: object) { [weak weakViewController] in
			SwiftyFormLog("did select option")
			(weakViewController as? SelectOptionDelegate)?.form_willSelectOption(option: object)
		}
		cells.append(cell)
		lastItemType = .item
	}

	// MARK: PrecisionSliderFormItem

	func visit(object: PrecisionSliderFormItem) {
		let model = PrecisionSliderCellModel()
		model.decimalPlaces = object.decimalPlaces
		model.minimumValue = object.minimumValue
		model.maximumValue = object.maximumValue
        model.style = object.style
		model.value = object.value
		model.title = object.title
		model.initialZoom = object.initialZoom
		model.zoomUI = object.zoomUI
		model.collapseWhenResigning = object.collapseWhenResigning
        model.prefix = object.prefix
        model.suffix = object.suffix
        model.titleFont = object.titleFont
        model.titleTextColor = object.titleTextColor
        model.detailTextColor = object.detailTextColor
        model.detailFont = object.detailFont

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
		lastItemType = .item

		cellExpanded.collapsedCell = cell
		cell.expandedCell = cellExpanded

		model.valueDidChange = { [weak object] (changeModel: PrecisionSliderCellModel.SliderDidChangeModel) in
			SwiftyFormLog("value did change \(changeModel.value)")
			let model = PrecisionSliderFormItem.SliderDidChangeModel(
				value: changeModel.value,
				valueUpdated: changeModel.valueUpdated,
				zoom: changeModel.zoom,
				zoomUpdated: changeModel.zoomUpdated
			)
			object?.sliderDidChange(model)
		}

		object.syncCellWithValue = { [weak cell, weak cellExpanded] (value: Int) in
			SwiftyFormLog("sync value \(value)")
			cell?.model.value = value
			cell?.reloadValueLabel()
			cellExpanded?.setValueWithoutSync(value)
		}
	}

	// MARK: SectionFooterTitleFormItem

	func visit(object: SectionFooterTitleFormItem) {
		if let title = object.title {
			footer = TableViewSectionPart.titleString(string: title)
		} else {
			footer = TableViewSectionPart.systemDefault
		}
		closeSection()
		lastItemType = .sectionEnd
	}

	// MARK: SectionFooterViewFormItem

	func visit(object: SectionFooterViewFormItem) {
		if let view: UIView = object.viewBlock?() {
			footer = TableViewSectionPart.titleView(view: view)
		} else {
			footer = TableViewSectionPart.systemDefault
		}
		closeSection()
		lastItemType = .sectionEnd
	}

	// MARK: SectionFormItem

	func visit(object: SectionFormItem) {
		switch lastItemType {
		case .beginning:
			break
		case .sectionEnd:
			break
		case .header:
			closeSection()
		case .item:
			closeSection()
		}
		lastItemType = .sectionEnd
	}

	// MARK: SectionHeaderTitleFormItem

	func visit(object: SectionHeaderTitleFormItem) {
		switch lastItemType {
		case .beginning:
			break
		case .sectionEnd:
			break
		case .header:
			closeSection()
		case .item:
			closeSection()
		}

		if let title = object.title {
			header = TableViewSectionPart.titleString(string: title)
		} else {
			header = TableViewSectionPart.systemDefault
		}
		lastItemType = .header
	}

	// MARK: SectionHeaderViewFormItem

	func visit(object: SectionHeaderViewFormItem) {
		switch lastItemType {
		case .beginning:
			break
		case .sectionEnd:
			break
		case .header:
			closeSection()
		case .item:
			closeSection()
		}

		if let view: UIView = object.viewBlock?() {
			header = TableViewSectionPart.titleView(view: view)
		} else {
			header = TableViewSectionPart.systemDefault
		}
		lastItemType = .header
	}

	// MARK: SegmentedControlFormItem

	func visit(object: SegmentedControlFormItem) {
		var model = SegmentedControlCellModel()
		model.title = object.title
		model.items = object.items
		model.value = object.selected

		model.valueDidChange = { [weak object] (value: Int) in
			SwiftyFormLog("value did change \(value)")
			object?.valueDidChange(value)
			return
		}

		let cell = SegmentedControlCell(model: model)
		cells.append(cell)
		lastItemType = .item

		object.syncCellWithValue = { [weak cell] (value: Int) in
			SwiftyFormLog("sync value \(value)")
			cell?.setValueWithoutSync(value)
			return
		}
	}

	// MARK: SliderFormItem

	func visit(object: SliderFormItem) {
		var model = SliderCellModel()
		model.minimumValue = object.minimumValue
		model.maximumValue = object.maximumValue
		model.value = object.value

		model.valueDidChange = { [weak object] (value: Float) in
			SwiftyFormLog("value did change \(value)")
			object?.sliderDidChange(value)
			return
		}

		let cell = SliderCell(model: model)
		cells.append(cell)
		lastItemType = .item

		object.syncCellWithValue = { [weak cell] (value: Float, animated: Bool) in
			SwiftyFormLog("sync value \(value)")
			cell?.setValueWithoutSync(value, animated: animated)
			return
		}
	}

	// MARK: StaticTextFormItem

	func visit(object: StaticTextFormItem) {
		var model = StaticTextCellModel()
		model.title = object.title
		model.value = object.value
        model.titleFont = object.titleFont
        model.titleTextColor = object.titleTextColor
        model.detailFont = object.detailFont
        model.detailTextColor = object.detailTextColor
        
		let cell = StaticTextCell(model: model)
		cells.append(cell)
		lastItemType = .item

		object.syncCellWithValue = { [weak cell] (value: String) in
			SwiftyFormLog("sync value \(value)")
			guard let cell = cell else { return }
			var model = StaticTextCellModel()
			model.title = cell.model.title
			model.value = value
			cell.model = model
			cell.loadWithModel(model)
		}
	}

	// MARK: StepperFormItem

	func visit(object: StepperFormItem) {
		var model = StepperCellModel()
		model.title = object.title
		model.value = object.value

		model.valueDidChange = { [weak object] (value: Int) in
			SwiftyFormLog("value \(value)")
			object?.innerValue = value
			return
		}

		let cell = StepperCell(model: model)
		cells.append(cell)
		lastItemType = .item

		SwiftyFormLog("will assign value \(object.value)")
		cell.setValueWithoutSync(object.value, animated: true)
		SwiftyFormLog("did assign value \(object.value)")

		object.syncCellWithValue = { [weak cell] (value: Int, animated: Bool) in
			SwiftyFormLog("sync value \(value)")
			cell?.setValueWithoutSync(value, animated: animated)
			return
		}
	}

	// MARK: SwitchFormItem

	func visit(object: SwitchFormItem) {
		var model = SwitchCellModel()
		model.title = object.title
        model.titleFont = object.titleFont
        model.titleTextColor = object.titleTextColor

		model.valueDidChange = { [weak object] (value: Bool) in
			SwiftyFormLog("value did change \(value)")
			object?.switchDidChange(value)
			return
		}

		let cell = SwitchCell(model: model)
		cells.append(cell)
		lastItemType = .item

		SwiftyFormLog("will assign value \(object.value)")
		cell.setValueWithoutSync(object.value, animated: false)
		SwiftyFormLog("did assign value \(object.value)")

		object.syncCellWithValue = { [weak cell] (value: Bool, animated: Bool) in
			SwiftyFormLog("sync value \(value)")
			cell?.setValueWithoutSync(value, animated: animated)
			return
		}
	}

	// MARK: TextFieldFormItem

	func visit(object: TextFieldFormItem) {
		var model = TextFieldFormItemCellModel()
		model.toolbarMode = self.model.toolbarMode
        model.textAlignment = object.textAlignment
        model.clearButtonMode = object.clearButtonMode
		model.title = object.title
		model.placeholder = object.placeholder
		model.keyboardType = object.keyboardType
		model.returnKeyType = object.returnKeyType
		model.autocorrectionType = object.autocorrectionType
		model.autocapitalizationType = object.autocapitalizationType
		model.spellCheckingType = object.spellCheckingType
		model.secureTextEntry = object.secureTextEntry
        model.titleFont = object.titleFont
        model.titleTextColor = object.titleTextColor
        model.detailFont = object.detailFont
        model.detailTextColor = object.titleTextColor
        model.errorFont = object.errorFont
        model.errorTextColor = object.errorTextColor
        
		model.model = object

		model.valueDidChange = { [weak object] (value: String) in
			SwiftyFormLog("value \(value)")
			object?.textDidChange(value)
			return
		}
        model.didEndEditing = { [weak object] (value: String) in
            SwiftyFormLog("value \(value)")
            object?.editingEnd(value)
            return
        }
		let cell = TextFieldFormItemCell(model: model)
		cell.setValueWithoutSync(object.value)
		cells.append(cell)
		lastItemType = .item

		object.syncCellWithValue = { [weak cell] (value: String) in
			SwiftyFormLog("sync value \(value)")
			cell?.setValueWithoutSync(value)
			return
		}

		object.reloadPersistentValidationState = { [weak cell] in
			cell?.reloadPersistentValidationState()
			return
		}

		object.obtainTitleWidth = { [weak cell] in
			return cell?.titleLabel.intrinsicContentSize.width ?? 0
		}

		object.assignTitleWidth = { [weak cell] (width: CGFloat) in
			cell?.titleWidthMode = TextFieldFormItemCell.TitleWidthMode.assign(width: width)
			cell?.setNeedsUpdateConstraints()
		}
	}

	// MARK: TextViewFormItem

	func visit(object: TextViewFormItem) {
		var model = TextViewCellModel()
		model.toolbarMode = self.model.toolbarMode
		model.title = object.title
		model.placeholder = object.placeholder
        model.placeholderTextColor = object.placeholderTextColor
        model.titleTextColor = object.titleTextColor
        model.titleFont = object.titleFont
        
		model.valueDidChange = { [weak object] (value: String) in
			SwiftyFormLog("value \(value)")
			object?.innerValue = value
			return
		}
		let cell = TextViewCell(model: model)
		cell.setValueWithoutSync(object.value)
		cells.append(cell)
		lastItemType = .item

		object.syncCellWithValue = { [weak cell] (value: String) in
			SwiftyFormLog("sync value \(value)")
			cell?.setValueWithoutSync(value)
			return
		}
	}

	// MARK: ViewControllerFormItem

	func visit(object: ViewControllerFormItem) {
		let model = ViewControllerFormItemCellModel(title: object.title, placeholder: object.placeholder)
		let willPopViewController = WillPopCustomViewController(object: object)

		let weakViewController = self.model.viewController
		let cell = ViewControllerFormItemCell(model: model) { [weak weakViewController] (cell: ViewControllerFormItemCell, _: ViewControllerFormItemCellModel) in
			SwiftyFormLog("push")
			guard let vc = weakViewController else { return }
			let dismissCommand = PopulateTableView.prepareDismissCommand(willPopViewController, parentViewController: vc, cell: cell)
			if let childViewController = object.createViewController?(dismissCommand) {
				vc.navigationController?.pushViewController(childViewController, animated: true)
			}
		}
		cells.append(cell)
		lastItemType = .item
	}

	class func prepareDismissCommand(_ willPopCommand: WillPopCommandProtocol, parentViewController: UIViewController, cell: ViewControllerFormItemCell) -> CommandProtocol {
		let command = CommandBlock { [weak parentViewController] (childViewController: UIViewController, returnObject: AnyObject?) in
			SwiftyFormLog("pop: \(String(describing: returnObject))")
			guard let vc = parentViewController else { return }
			let context = ViewControllerFormItemPopContext(parentViewController: vc, childViewController: childViewController, cell: cell, returnedObject: returnObject)
			willPopCommand.execute(context)
			vc.navigationController?.popViewController(animated: true)
		}
		return command
	}

	// MARK: PickerViewFormItem

	func visit(object: PickerViewFormItem) {
		let model = PickerViewCellModel()
		model.title = object.title
		model.value = object.value
		model.titles = object.pickerTitles
        model.titleFont = object.titleFont
        model.titleTextColor = object.titleTextColor
        model.detailFont = object.detailFont
        model.detailTextColor = object.detailTextColor
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
		lastItemType = .item

		cellExpanded.collapsedCell = cell
		cell.expandedCell = cellExpanded

		cellExpanded.configure(model)

		object.syncCellWithValue = { [weak cell] (value: [Int], animated: Bool) in
			SwiftyFormLog("sync value \(value)")
			cell?.setValueWithoutSync(value, animated: animated)
		}

		model.valueDidChange = { [weak object] (selectedRows: [Int]) in
			SwiftyFormLog("value did change \(selectedRows)")
			object?.valueDidChange(selectedRows)
		}
	}
}
