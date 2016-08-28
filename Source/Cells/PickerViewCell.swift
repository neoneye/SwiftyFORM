// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

struct PickerViewCellConstants {
	struct CellExpanded {
		static let height: CGFloat = 216
	}
}


public class PickerViewCellModel {
	var title: String = ""
	var expandCollapseWhenSelectingRow = true
	var selectionStyle = UITableViewCellSelectionStyle.Default
	
	var titles = [[String]]()
	var value = [Int]()
	
	var valueDidChange: [Int] -> Void = { (selectedRows: [Int]) in
		SwiftyFormLog("selectedRows \(selectedRows)")
	}

	var humanReadableValue: String {
		var result = [String]()
		for (component, row) in value.enumerate() {
			let title = titles[component][row]
			result.append(title)
		}
		return result.joinWithSeparator(",")
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
		super.init(style: .Value1, reuseIdentifier: nil)
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
	
	func setValueWithoutSync(value: [Int], animated: Bool) {
		if value.count != model.titles.count {
			print("Expected the number of components to be the same")
			return
		}
		SwiftyFormLog("set value \(value), animated \(animated)")
		model.value = value
		updateValue()
		
		expandedCell?.pickerView.form_selectRows(value, animated: animated)
	}
	
	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		return 60
	}
	
	public func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView) {
		if model.expandCollapseWhenSelectingRow == false {
			//print("cell is always expanded")
			return
		}

		if isExpandedCellVisible {
			resignFirstResponder()
		} else {
			becomeFirstResponder()
		}
		form_deselectRow()
	}


	// MARK: UIResponder
	
	public override func canBecomeFirstResponder() -> Bool {
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
		textLabel?.textColor = UIColor.blackColor()
		detailTextLabel?.textColor = UIColor.grayColor()
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
public class PickerViewExpandedCell: UITableViewCell, CellHeightProvider, WillDisplayCellDelegate, ExpandedCell, UIPickerViewDataSource, UIPickerViewDelegate {
	weak var collapsedCell: PickerViewToggleCell?

	public var toggleCell: UITableViewCell? {
		return collapsedCell
	}
	
	public var isCollapsable: Bool {
		return collapsedCell?.model.expandCollapseWhenSelectingRow ?? false
	}

	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		return PickerViewCellConstants.CellExpanded.height
	}

	public func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: NSIndexPath) {
		if let model = collapsedCell?.model {
			configure(model)
		}
	}

	lazy var pickerView: UIPickerView = {
		let instance = UIPickerView()
		instance.dataSource = self
		instance.delegate = self
		return instance
	}()
	
	var titles = [[String]]()
	
	func configure(model: PickerViewCellModel) {
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
		for (component, _) in titles.enumerate() {
			let row: Int = pickerView.selectedRowInComponent(component)
			selectedRows.append(row)
		}
		print("selected rows: \(selectedRows)")
		
		model.value = selectedRows
		collapsedCell.updateValue()
		model.valueDidChange(selectedRows)
	}
	
	public init() {
		super.init(style: .Default, reuseIdentifier: nil)
		addSubview(pickerView)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		pickerView.frame = bounds
	}

	// MARK: UIPickerViewDataSource / UIPickerViewDelegate
	
	public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return titles.count
	}
	
	public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return titles[component].count
	}
	
	public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return titles[component][row]
	}
	
	public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		valueChanged()
	}
}

extension UIPickerView {
	func form_selectRows(rows: [Int], animated: Bool) {
		for (component, row) in rows.enumerate() {
			selectRow(row, inComponent: component, animated: animated)
		}
	}
}
