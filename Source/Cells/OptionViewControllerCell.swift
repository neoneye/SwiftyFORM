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
		// hide keyboard when the user taps this kind of row
		tableView.form_firstResponder()?.resignFirstResponder()
		
		weak var weakCell = self
		let dismissCommand = CommandBlock { (childViewController: UIViewController, returnObject: AnyObject?) in
			if let cell = weakCell {
				if let pickedOption = returnObject as? OptionRowModel {
					DLog("pick ok")
					cell.setValueAndSync(pickedOption)
				} else {
					DLog("pick none")
					cell.setValueAndSync(nil)
				}
			}
			childViewController.navigationController?.popViewControllerAnimated(true)
			return
		}
		
		if let vc = parentViewController {
			if let optionField = model.optionField {
				let childViewController = OptionViewController(dismissCommand: dismissCommand, optionField: optionField)
				vc.navigationController?.pushViewController(childViewController, animated: true)
			}
		}

		DLog("did invoke")
	}
}
