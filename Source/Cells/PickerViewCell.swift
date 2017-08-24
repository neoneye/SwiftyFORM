// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

struct PickerViewCellConstants {
	struct CellExpanded {
		static let height: CGFloat = 216
	}
}

public class PickerViewCellModel {
	var title: String = ""
	var expandCollapseWhenSelectingRow = true
	var selectionStyle = UITableViewCellSelectionStyle.default

	var titles = [[String]]()
	var value = [Int]()
	var humanReadableValueSeparator: String?

	var valueDidChange: ([Int]) -> Void = { (selectedRows: [Int]) in
		SwiftyFormLog("selectedRows \(selectedRows)")
	}

	var humanReadableValue: String {
		var result = [String]()
		for (component, row) in value.enumerated() {
			let title = titles[component][row]
			result.append(title)
		}
		return result.joined(separator: humanReadableValueSeparator ?? ",")
	}
}

/**
# Picker view toggle-cell

### Tap this row to toggle

This causes the inline picker view to expand/collapse
*/
public class PickerViewToggleCell: UITableViewCell, SelectRowDelegate, DontCollapseWhenScrolling, AssignAppearance {
	weak var expandedCell: PickerViewExpandedCell?
	public let model: PickerViewCellModel

	public init(model: PickerViewCellModel) {
		self.model = model
		super.init(style: .value1, reuseIdentifier: nil)
		selectionStyle = model.selectionStyle
		textLabel?.text = model.title

		updateValue()

		assignDefaultColors()
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	public func updateValue() {
		detailTextLabel?.text = model.humanReadableValue
	}

	func setValueWithoutSync(_ value: [Int], animated: Bool) {
		if value.count != model.titles.count {
			print("Expected the number of components to be the same")
			return
		}
		SwiftyFormLog("set value \(value), animated \(animated)")
		model.value = value
		updateValue()

		expandedCell?.pickerView.form_selectRows(value, animated: animated)
	}

	public func form_cellHeight(_ indexPath: IndexPath, tableView: UITableView) -> CGFloat {
		return 60
	}

	public func form_didSelectRow(indexPath: IndexPath, tableView: UITableView) {
		if model.expandCollapseWhenSelectingRow == false {
			//print("cell is always expanded")
			return
		}

		if isExpandedCellVisible {
			_ = resignFirstResponder()
		} else {
			_ = becomeFirstResponder()
		}
		form_deselectRow()
	}

	// MARK: UIResponder

	public override var canBecomeFirstResponder: Bool {
		if model.expandCollapseWhenSelectingRow == false {
			return false
		}
		return true
	}

	public override func becomeFirstResponder() -> Bool {
		if !super.becomeFirstResponder() {
			return false
		}
		expand()
		return true
	}

	public override func resignFirstResponder() -> Bool {
		collapse()
		return super.resignFirstResponder()
	}

	// MARK: Expand collapse

	var isExpandedCellVisible: Bool {
		guard let sectionArray = form_tableView()?.dataSource as? TableViewSectionArray else {
			return false
		}
		guard let expandedItem = sectionArray.findItem(expandedCell) else {
			return false
		}
		if expandedItem.hidden {
			return false
		}
		return true
	}

	func toggleExpandCollapse() {
		guard let tableView = form_tableView() else {
			return
		}
		guard let sectionArray = tableView.dataSource as? TableViewSectionArray else {
			return
		}
		guard let expandedCell = expandedCell else {
			return
		}
		ToggleExpandCollapse.execute(
			toggleCell: self,
			expandedCell: expandedCell,
			tableView: tableView,
			sectionArray: sectionArray
		)
	}

	func expand() {
		if isExpandedCellVisible {
			assignTintColors()
		} else {
			toggleExpandCollapse()
		}
	}

	func collapse() {
		if isExpandedCellVisible {
			toggleExpandCollapse()
		}
	}

	// MARK: AssignAppearance

	public func assignDefaultColors() {
		textLabel?.textColor = UIColor.black
		detailTextLabel?.textColor = UIColor.gray
	}

	public func assignTintColors() {
		textLabel?.textColor = tintColor
		detailTextLabel?.textColor = tintColor
	}
}

/**
# Picker view expanded-cell

Row containing only a `UIPickerView`
*/
public class PickerViewExpandedCell: UITableViewCell {
	weak var collapsedCell: PickerViewToggleCell?

	lazy var pickerView: UIPickerView = {
		let instance = UIPickerView()
		instance.dataSource = self
		instance.delegate = self
		return instance
	}()

	var titles = [[String]]()

	func configure(_ model: PickerViewCellModel) {
		titles = model.titles
		pickerView.reloadAllComponents()
		pickerView.setNeedsLayout()
		pickerView.form_selectRows(model.value, animated: false)
	}

	public func valueChanged() {
		guard let collapsedCell = collapsedCell else {
			return
		}
		let model = collapsedCell.model

		var selectedRows = [Int]()
		for (component, _) in titles.enumerated() {
			let row: Int = pickerView.selectedRow(inComponent: component)
			selectedRows.append(row)
		}
		//print("selected rows: \(selectedRows)")

		model.value = selectedRows
		collapsedCell.updateValue()
		model.valueDidChange(selectedRows)
	}

	public init() {
		super.init(style: .default, reuseIdentifier: nil)
		contentView.addSubview(pickerView)
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	fileprivate var componentWidth: CGFloat = 0

	public override func layoutSubviews() {
		super.layoutSubviews()
		pickerView.frame = contentView.bounds

		// Ensures that all UIPickerView components stay within the left/right layoutMargins
		let rect = UIEdgeInsetsInsetRect(pickerView.frame, layoutMargins)
		let numberOfComponents = titles.count
		if numberOfComponents >= 1 {
			componentWidth = rect.width / CGFloat(numberOfComponents)
		} else {
			componentWidth = rect.width
		}

		/*
		Workaround:
		UIPickerView gets messed up on orientation change
		
		This is a very old problem
		On iOS9, as of 29 aug 2016, it's still a problem.
		http://stackoverflow.com/questions/7576679/uipickerview-as-inputview-gets-messed-up-on-orientation-change
		http://stackoverflow.com/questions/9767234/why-wont-uipickerview-resize-the-first-time-i-change-device-orientation-on-its
		
		The following line solves the problem.
		*/
		pickerView.setNeedsLayout()
	}
}

extension PickerViewExpandedCell: UIPickerViewDataSource {
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return titles.count
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return titles[component].count
	}
}

extension PickerViewExpandedCell: UIPickerViewDelegate {
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return titles[component][row]
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		valueChanged()
	}

	public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 44
	}

	public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return componentWidth
	}
}

extension PickerViewExpandedCell: CellHeightProvider {
	public func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
		return PickerViewCellConstants.CellExpanded.height
	}
}

extension PickerViewExpandedCell: WillDisplayCellDelegate {
	public func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath) {
		if let model = collapsedCell?.model {
			configure(model)
		}
	}
}

extension PickerViewExpandedCell: ExpandedCell {
	public var toggleCell: UITableViewCell? {
		return collapsedCell
	}

	public var isCollapsable: Bool {
		return collapsedCell?.model.expandCollapseWhenSelectingRow ?? false
	}
}

extension UIPickerView {
	func form_selectRows(_ rows: [Int], animated: Bool) {
		for (component, row) in rows.enumerated() {
			selectRow(row, inComponent: component, animated: animated)
		}
	}
}
