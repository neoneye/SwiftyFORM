// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
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

public class TextViewCell: UITableViewCell, UITextViewDelegate, CellHeightProvider {
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
		textView.textContainerInset = UIEdgeInsetsMake(5, 16, 10, 16)

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
	
	public func handleTap(_ sender: UITapGestureRecognizer) {
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
	
	public func textViewDidBeginEditing(_ textView: UITextView) {
		updateToolbarButtons()
	}

	public func textViewDidChange(_ textView: UITextView) {
		updateValue()
		model.valueDidChange(textView.text)
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
	
	public func compute(_ cellWidth: CGFloat) -> TextViewFormItemCellSizes {
		
		var titleLabelFrame = CGRect.zero
		var placeholderLabelFrame = CGRect.zero
		var textViewFrame = CGRect.zero
		let errorLabelFrame = CGRect.zero
		var maxY: CGFloat = 0
		let veryTallCell = CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat.greatestFiniteMagnitude)
		var (slice, remainder) = veryTallCell.divided(atDistance: 10, from: .minYEdge)
		
		if true {
			let dx: CGFloat = 16
			var availableSize = veryTallCell.size
			availableSize.width -= dx * 2
			let size = titleLabel.sizeThatFits(availableSize)
			(slice, remainder) = remainder.divided(atDistance: size.height, from: .minYEdge)
			titleLabelFrame = slice.insetBy(dx: dx, dy: 0)
		}
		
		let bottomRemainder = remainder
		
		if true {
			(slice, remainder) = bottomRemainder.divided(atDistance: 5.5, from: .minYEdge)
			let dx: CGFloat = 16
			var availableSize = veryTallCell.size
			availableSize.width -= dx * 2
			let size = placeholderLabel.sizeThatFits(availableSize)
			(slice, remainder) = remainder.divided(atDistance: size.height, from: .minYEdge)
			placeholderLabelFrame = slice.insetBy(dx: dx, dy: 0)
		}
		(slice, remainder) = remainder.divided(atDistance: 10, from: .minYEdge)
		maxY = slice.maxY
		
		if true {
			let availableSize = veryTallCell.size
			let size = textView.sizeThatFits(availableSize)
			(slice, remainder) = bottomRemainder.divided(atDistance: size.height, from: .minYEdge)
			textViewFrame = slice
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
		
		let sizes: TextViewFormItemCellSizes = compute(bounds.width)
		titleLabel.frame = sizes.titleLabelFrame
		placeholderLabel.frame = sizes.placeholderLabelFrame
		textView.frame = sizes.textViewFrame
	}
	
	public func form_cellHeight(_ indexPath: IndexPath, tableView: UITableView) -> CGFloat {
		let sizes: TextViewFormItemCellSizes = compute(bounds.width)
		let value = sizes.cellHeight
		//SwiftyFormLog("compute height of row: \(value)")
		return value
	}
	
	// MARK: UIResponder
	
	public override var canBecomeFirstResponder : Bool {
		return true
	}
	
	public override func becomeFirstResponder() -> Bool {
		return textView.becomeFirstResponder()
	}
	
	public override func resignFirstResponder() -> Bool {
		return textView.resignFirstResponder()
	}
}
