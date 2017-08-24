// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

public struct TextViewFormItemCellSizes {
	var titleLabelFrame: CGRect = CGRect.zero
	var placeholderLabelFrame: CGRect = CGRect.zero
	var textViewFrame: CGRect = CGRect.zero
	var errorLabelFrame: CGRect = CGRect.zero
	var cellHeight: CGFloat = 0
}

public struct TextViewCellModel {
	var title: String = ""
	var placeholder: String = ""
	var toolbarMode: ToolbarMode = .simple

	var valueDidChange: (String) -> Void = { (value: String) in
		SwiftyFormLog("value \(value)")
	}
}

public class TextViewCell: UITableViewCell {
	public let titleLabel = UILabel()
	public let placeholderLabel = UILabel()
	public let textView = UITextView()
	public let model: TextViewCellModel

	public init(model: TextViewCellModel) {
		self.model = model
		super.init(style: .value1, reuseIdentifier: nil)
		selectionStyle = .none

		titleLabel.text = model.title
		titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)

		placeholderLabel.text = model.placeholder
		placeholderLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
		placeholderLabel.textColor = UIColor.lightGray

		textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
		textView.textColor = UIColor.black
		textView.backgroundColor = UIColor.clear
		textView.isScrollEnabled = false
		textView.delegate = self
		textView.textContainer.lineFragmentPadding = 0

		if model.toolbarMode == .simple {
			textView.inputAccessoryView = toolbar
		}

		contentView.addSubview(textView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(placeholderLabel)

		clipsToBounds = true

		self.addGestureRecognizer(tapGestureRecognizer)
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc public func handleTap(_ sender: UITapGestureRecognizer) {
		_ = self.becomeFirstResponder()
	}

	public lazy var tapGestureRecognizer: UITapGestureRecognizer = {
		let gr = UITapGestureRecognizer(target: self, action: #selector(TextViewCell.handleTap(_:)))
		return gr
		}()

	public lazy var toolbar: SimpleToolbar = {
		let instance = SimpleToolbar()
		weak var weakSelf = self
		instance.jumpToPrevious = {
			if let cell = weakSelf {
				cell.gotoPrevious()
			}
		}
		instance.jumpToNext = {
			if let cell = weakSelf {
				cell.gotoNext()
			}
		}
		instance.dismissKeyboard = {
			if let cell = weakSelf {
				cell.dismissKeyboard()
			}
		}
		return instance
		}()

	public func updateToolbarButtons() {
		if model.toolbarMode == .simple {
			toolbar.updateButtonConfiguration(self)
		}
	}

	public func gotoPrevious() {
		SwiftyFormLog("make previous cell first responder")
		form_makePreviousCellFirstResponder()
	}

	public func gotoNext() {
		SwiftyFormLog("make next cell first responder")
		form_makeNextCellFirstResponder()
	}

	public func dismissKeyboard() {
		SwiftyFormLog("dismiss keyboard")
		_ = resignFirstResponder()
	}

	public func updateValue() {
		let s = textView.text
		let hasText = (s?.characters.count)! > 0
		placeholderLabel.isHidden = hasText

		let tableView: UITableView? = form_tableView()
		if let tv = tableView {
			setNeedsLayout()
			tv.beginUpdates()
			tv.endUpdates()
		}
	}

	public func setValueWithoutSync(_ value: String) {
		SwiftyFormLog("set value \(value)")
		textView.text = value
		updateValue()
	}

	public func compute() -> TextViewFormItemCellSizes {
		let cellWidth: CGFloat = bounds.width

		var titleLabelFrame = CGRect.zero
		var placeholderLabelFrame = CGRect.zero
		var textViewFrame = CGRect.zero
		let errorLabelFrame = CGRect.zero
		var maxY: CGFloat = 0
		var veryTallCell = CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat.greatestFiniteMagnitude)

		var layoutMargins = self.layoutMargins
		layoutMargins.top = 0
		layoutMargins.bottom = 0
		veryTallCell = UIEdgeInsetsInsetRect(veryTallCell, layoutMargins)

		var (slice, remainder) = veryTallCell.divided(atDistance: 10, from: .minYEdge)

		do {
			let size = titleLabel.sizeThatFits(veryTallCell.size)
			(slice, remainder) = remainder.divided(atDistance: size.height, from: .minYEdge)
			titleLabelFrame = slice
		}

		let bottomRemainder = remainder

		do {
			(slice, remainder) = bottomRemainder.divided(atDistance: 5.5, from: .minYEdge)
			let size = placeholderLabel.sizeThatFits(veryTallCell.size)
			(slice, remainder) = remainder.divided(atDistance: size.height, from: .minYEdge)
			placeholderLabelFrame = slice
		}
		(slice, remainder) = remainder.divided(atDistance: 10, from: .minYEdge)
		maxY = slice.maxY

		do {
			let availableSize = veryTallCell.size
			let size = textView.sizeThatFits(availableSize)
			(slice, remainder) = bottomRemainder.divided(atDistance: size.height, from: .minYEdge)
			textViewFrame = CGRect(x: bounds.minX, y: slice.minY, width: bounds.width, height: slice.height)
		}
		maxY = max(textViewFrame.maxY, maxY)

		var result = TextViewFormItemCellSizes()
		result.titleLabelFrame = titleLabelFrame
		result.placeholderLabelFrame = placeholderLabelFrame
		result.textViewFrame = textViewFrame
		result.errorLabelFrame = errorLabelFrame
		result.cellHeight = ceil(maxY)
		return result
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		let sizes: TextViewFormItemCellSizes = compute()
		titleLabel.frame = sizes.titleLabelFrame
		placeholderLabel.frame = sizes.placeholderLabelFrame
		textView.frame = sizes.textViewFrame

		var textViewInset = self.layoutMargins
		textViewInset.top = 5
		textViewInset.bottom = 10
		textView.textContainerInset = textViewInset
	}

	// MARK: UIResponder

	public override var canBecomeFirstResponder: Bool {
		return true
	}

	public override func becomeFirstResponder() -> Bool {
		return textView.becomeFirstResponder()
	}

	public override func resignFirstResponder() -> Bool {
		return textView.resignFirstResponder()
	}
}

extension TextViewCell: UITextViewDelegate {
	public func textViewDidBeginEditing(_ textView: UITextView) {
		updateToolbarButtons()
	}

	public func textViewDidChange(_ textView: UITextView) {
		updateValue()
		model.valueDidChange(textView.text)
	}
}

extension TextViewCell: CellHeightProvider {
	public func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
		let sizes: TextViewFormItemCellSizes = compute()
		let value = sizes.cellHeight
		//SwiftyFormLog("compute height of row: \(value)")
		return value
	}
}
