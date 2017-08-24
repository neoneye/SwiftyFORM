// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

public struct OptionViewControllerCellModel {
	var title: String = ""
	var placeholder: String = ""
	var optionField: OptionPickerFormItem?
	var selectedOptionRow: OptionRowModel?

	var valueDidChange: (OptionRowModel?) -> Void = { (value: OptionRowModel?) in
		SwiftyFormLog("value \(String(describing: value))")
	}
}

public class OptionViewControllerCell: UITableViewCell, SelectRowDelegate {
	fileprivate let model: OptionViewControllerCellModel
	fileprivate var selectedOptionRow: OptionRowModel?
	fileprivate weak var parentViewController: UIViewController?

	public init(parentViewController: UIViewController, model: OptionViewControllerCellModel) {
		self.parentViewController = parentViewController
		self.model = model
		self.selectedOptionRow = model.selectedOptionRow
		super.init(style: .value1, reuseIdentifier: nil)
		accessoryType = .disclosureIndicator
		textLabel?.text = model.title
		updateValue()
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	fileprivate func humanReadableValue() -> String? {
		if let option = selectedOptionRow {
			return option.title
		} else {
			return model.placeholder
		}
	}

	fileprivate func updateValue() {
		let s = humanReadableValue()
		SwiftyFormLog("update value \(String(describing: s))")
		detailTextLabel?.text = s
	}

	public func setSelectedOptionRowWithoutPropagation(_ option: OptionRowModel?) {
		SwiftyFormLog("set selected option: \(String(describing: option?.title)) \(String(describing: option?.identifier))")

		selectedOptionRow = option
		updateValue()
	}

	fileprivate func viaOptionList_userPickedOption(_ option: OptionRowModel) {
		SwiftyFormLog("user picked option: \(option.title) \(option.identifier)")

		if selectedOptionRow === option {
			SwiftyFormLog("no change")
			return
		}

		selectedOptionRow = option
		updateValue()
		model.valueDidChange(option)
	}

	public func form_didSelectRow(indexPath: IndexPath, tableView: UITableView) {
		SwiftyFormLog("will invoke")

		guard let vc: UIViewController = parentViewController else {
			SwiftyFormLog("Expected a parent view controller")
			return
		}
		guard let nc: UINavigationController = vc.navigationController else {
			SwiftyFormLog("Expected parent view controller to have a navigation controller")
			return
		}
		guard let optionField = model.optionField else {
			SwiftyFormLog("Expected model to have an optionField")
			return
		}

		// hide keyboard when the user taps this kind of row
		tableView.form_firstResponder()?.resignFirstResponder()

		let childViewController = OptionListViewController(optionField: optionField) { [weak self] (selected: OptionRowModel) in
			self?.viaOptionList_userPickedOption(selected)
			nc.popViewController(animated: true)
		}
		nc.pushViewController(childViewController, animated: true)

		SwiftyFormLog("did invoke")
	}
}
