// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public struct OptionViewControllerCellModel {
	var title: String = ""
	var placeholder: String = ""
	var optionField: OptionPickerFormItem? = nil

	var valueDidChange: OptionRowModel? -> Void = { (value: OptionRowModel?) in
		DLog("value \(value)")
	}
}

public class OptionViewControllerCell: UITableViewCell, SelectRowDelegate {
	public let model: OptionViewControllerCellModel
	public var selectedOptionRow: OptionRowModel? = nil
	weak var parentViewController: UIViewController?
	
	public init(model: OptionViewControllerCellModel) {
		self.model = model
		super.init(style: .Value1, reuseIdentifier: nil)
		accessoryType = .DisclosureIndicator
		textLabel?.text = model.title
		detailTextLabel?.text = model.placeholder
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func humanReadableValue() -> String? {
		if let option = selectedOptionRow {
			return option.title
		} else {
			return model.placeholder
		}
	}
	
	public func updateValue() {
		let s = humanReadableValue()
		DLog("update value \(s)")
		detailTextLabel?.text = humanReadableValue()
	}
	
	public func setValueWithoutSync(value: OptionRowModel?) {
		DLog("set value \(value)")
		selectedOptionRow = value
		updateValue()
	}
	
	public func setValueAndSync(value: OptionRowModel?) {
		selectedOptionRow = value
		model.valueDidChange(selectedOptionRow)
		updateValue()
	}

	public func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView) {
		DLog("will invoke")
		
		guard let vc: UIViewController = parentViewController else {
			DLog("Expected a parent view controller")
			return
		}
		guard let nc: UINavigationController = vc.navigationController else {
			DLog("Expected parent view controller to have a navigation controller")
			return
		}
		guard let optionField = model.optionField else {
			DLog("Expected model to have an optionField")
			return
		}
		
		// hide keyboard when the user taps this kind of row
		tableView.form_firstResponder()?.resignFirstResponder()

		let childViewController = OptionListViewController(optionField: optionField) { [weak self] (selected: OptionRowModel) in
			DLog("user selected option: \(selected.title)")
			self?.setValueAndSync(selected)
			nc.popViewControllerAnimated(true)
		}
		nc.pushViewController(childViewController, animated: true)
		
		DLog("did invoke")
	}
}
