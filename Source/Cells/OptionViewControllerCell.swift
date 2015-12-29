// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public struct OptionViewControllerCellModel {
	var title: String = ""
	var placeholder: String = ""
	var optionField: OptionPickerFormItem? = nil
	var selectedOptionRow: OptionRowModel? = nil

	var valueDidChange: OptionRowModel? -> Void = { (value: OptionRowModel?) in
		DLog("value \(value)")
	}
}

public class OptionViewControllerCell: UITableViewCell, SelectRowDelegate {
	private let model: OptionViewControllerCellModel
	private var selectedOptionRow: OptionRowModel? = nil
	private weak var parentViewController: UIViewController?
	
	public init(parentViewController: UIViewController, model: OptionViewControllerCellModel) {
		self.parentViewController = parentViewController
		self.model = model
		self.selectedOptionRow = model.selectedOptionRow
		super.init(style: .Value1, reuseIdentifier: nil)
		accessoryType = .DisclosureIndicator
		textLabel?.text = model.title
		updateValue()
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func humanReadableValue() -> String? {
		if let option = selectedOptionRow {
			return option.title
		} else {
			return model.placeholder
		}
	}
	
	private func updateValue() {
		let s = humanReadableValue()
		DLog("update value \(s)")
		detailTextLabel?.text = s
	}
	
	public func setSelectedOptionRowWithoutPropagation(option: OptionRowModel?) {
		DLog("set selected option: \(option?.title) \(option?.identifier)")
		
		selectedOptionRow = option
		updateValue()
	}
	
	private func viaOptionList_userPickedOption(option: OptionRowModel) {
		DLog("user picked option: \(option.title) \(option.identifier)")
		
		if selectedOptionRow === option {
			DLog("no change")
			return
		}
		
		selectedOptionRow = option
		updateValue()
		model.valueDidChange(option)
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
			self?.viaOptionList_userPickedOption(selected)
			nc.popViewControllerAnimated(true)
		}
		nc.pushViewController(childViewController, animated: true)
		
		DLog("did invoke")
	}
}
