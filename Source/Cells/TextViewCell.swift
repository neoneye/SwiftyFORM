// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public struct TextViewFormItemCellSizes {
	var titleLabelFrame: CGRect = CGRectZero
	var placeholderLabelFrame: CGRect = CGRectZero
	var textViewFrame: CGRect = CGRectZero
	var errorLabelFrame: CGRect = CGRectZero
	var cellHeight: CGFloat = 0
}

public struct TextViewCellModel {
	var title: String = ""
	var placeholder: String = ""
	var toolbarMode: ToolbarMode = .Simple

	var valueDidChange: String -> Void = { (value: String) in
		DLog("value \(value)")
	}
}

public class TextViewCell: UITableViewCell, UITextViewDelegate, CellHeightProvider {
	public let titleLabel = UILabel()
	public let placeholderLabel = UILabel()
	public let textView = UITextView()
	public let model: TextViewCellModel
	
	public init(model: TextViewCellModel) {
		self.model = model
		super.init(style: .Value1, reuseIdentifier: nil)
		selectionStyle = .None

		titleLabel.text = model.title
		titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

		placeholderLabel.text = model.placeholder
		placeholderLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		placeholderLabel.textColor = UIColor.lightGrayColor()

		textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		textView.textColor = UIColor.blackColor()
		textView.backgroundColor = UIColor.clearColor()
		textView.scrollEnabled = false
		textView.delegate = self

		textView.textContainer.lineFragmentPadding = 0
		textView.textContainerInset = UIEdgeInsetsMake(5, 16, 10, 16)

		if model.toolbarMode == .Simple {
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
	
	public func handleTap(sender: UITapGestureRecognizer) {
		self.becomeFirstResponder()
	}
	
	public lazy var tapGestureRecognizer: UITapGestureRecognizer = {
		let gr = UITapGestureRecognizer(target: self, action: "handleTap:")
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
		if model.toolbarMode == .Simple {
			toolbar.updateButtonConfiguration(self)
		}
	}
	
	public func gotoPrevious() {
		DLog("make previous cell first responder")
		form_makePreviousCellFirstResponder()
	}
	
	public func gotoNext() {
		DLog("make next cell first responder")
		form_makeNextCellFirstResponder()
	}
	
	public func dismissKeyboard() {
		DLog("dismiss keyboard")
		resignFirstResponder()
	}
	
	public func textViewDidBeginEditing(textView: UITextView) {
		updateToolbarButtons()
	}

	public func textViewDidChange(textView: UITextView) {
		updateValue()
		model.valueDidChange(textView.text)
	}

	public func updateValue() {
		let s = textView.text
		let hasText = s.characters.count > 0
		placeholderLabel.hidden = hasText
		
		let tableView: UITableView? = form_tableView()
		if let tv = tableView {
			setNeedsLayout()
			tv.beginUpdates()
			tv.endUpdates()
		}
	}
	
	public func setValueWithoutSync(value: String) {
		DLog("set value \(value)")
		textView.text = value
		updateValue()
	}
	
	public func compute(cellWidth: CGFloat) -> TextViewFormItemCellSizes {
		
		var titleLabelFrame = CGRectZero
		var placeholderLabelFrame = CGRectZero
		var textViewFrame = CGRectZero
		let errorLabelFrame = CGRectZero
		var maxY: CGFloat = 0
		let veryTallCell = CGRectMake(0, 0, cellWidth, CGFloat.max)
		var (slice, remainder) = veryTallCell.divide(10, fromEdge: .MinYEdge)
		
		if true {
			let dx: CGFloat = 16
			var availableSize = veryTallCell.size
			availableSize.width -= dx * 2
			let size = titleLabel.sizeThatFits(availableSize)
			(slice, remainder) = remainder.divide(size.height, fromEdge: .MinYEdge)
			titleLabelFrame = slice.insetBy(dx: dx, dy: 0)
		}
		
		let bottomRemainder = remainder
		
		if true {
			(slice, remainder) = bottomRemainder.divide(5.5, fromEdge: .MinYEdge)
			let dx: CGFloat = 16
			var availableSize = veryTallCell.size
			availableSize.width -= dx * 2
			let size = placeholderLabel.sizeThatFits(availableSize)
			(slice, remainder) = remainder.divide(size.height, fromEdge: .MinYEdge)
			placeholderLabelFrame = slice.insetBy(dx: dx, dy: 0)
		}
		(slice, remainder) = remainder.divide(10, fromEdge: .MinYEdge)
		maxY = slice.maxY
		
		if true {
			let availableSize = veryTallCell.size
			let size = textView.sizeThatFits(availableSize)
			(slice, remainder) = bottomRemainder.divide(size.height, fromEdge: .MinYEdge)
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
	
	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		let sizes: TextViewFormItemCellSizes = compute(bounds.width)
		let value = sizes.cellHeight
		//DLog("compute height of row: \(value)")
		return value
	}
	
	// MARK: UIResponder
	
	public override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	public override func becomeFirstResponder() -> Bool {
		return textView.becomeFirstResponder()
	}
	
	public override func resignFirstResponder() -> Bool {
		return textView.resignFirstResponder()
	}
}
