// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
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
    var titleFont: UIFont = .preferredFont(forTextStyle: .body)
    var titleTextColor: UIColor = Colors.text
    var placeholderTextColor: UIColor = Colors.secondaryText

	var valueDidChange: (String) -> Void = { (value: String) in
		SwiftyFormLog("value \(value)")
	}
}

public class TextViewCell: UITableViewCell, AssignAppearance {
    
	public let titleLabel = UILabel()
	public let placeholderLabel = UILabel()
	public let textView = UITextView()
	public let model: TextViewCellModel
    
    /// keeps track of the current height as seen by the tableView,, so we can reload the tableView if needed to get an accurate height for this cell
    private var reloadIndexPath: IndexPath?
    private var believedHeight: CGFloat = 0

	public init(model: TextViewCellModel) {
		self.model = model
		super.init(style: .value1, reuseIdentifier: nil)
		selectionStyle = .none

		titleLabel.text = model.title
		titleLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)

		placeholderLabel.text = model.placeholder
        placeholderLabel.font = model.titleFont
        placeholderLabel.textColor = model.placeholderTextColor

        textView.font = model.titleFont
        textView.textColor = model.titleTextColor
		textView.backgroundColor = UIColor.clear
		textView.isScrollEnabled = false
		textView.delegate = self
		textView.textContainer.lineFragmentPadding = 0

		if model.toolbarMode == .simple {
			textView.inputAccessoryView = toolbar
		}
        
        if #available(iOS 11, *) {
            contentView.insetsLayoutMarginsFromSafeArea = true
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

	public lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TextViewCell.handleTap(_:)))
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        layoutSubviews()
    }

	public lazy var toolbar: SimpleToolbar = {
		let instance = SimpleToolbar()
		instance.jumpToPrevious = { [weak self] in
			self?.gotoPrevious()
		}
		instance.jumpToNext = { [weak self] in
			self?.gotoNext()
		}
		instance.dismissKeyboard = { [weak self] in
			self?.dismissKeyboard()
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
		let s = textView.text ?? ""
		let hasText = !s.isEmpty
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
        let cellWidth: CGFloat = contentView.bounds.width

		var titleLabelFrame = CGRect.zero
		var placeholderLabelFrame = CGRect.zero
		var textViewFrame = CGRect.zero
		let errorLabelFrame = CGRect.zero
		var maxY: CGFloat = 0
		var veryTallCell = CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat.greatestFiniteMagnitude)

		var layoutMargins = contentView.layoutMargins
		layoutMargins.top = 0
		layoutMargins.bottom = 0
		veryTallCell = veryTallCell.inset(by: layoutMargins)

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
            textViewFrame = CGRect(x: contentView.bounds.minX, y: slice.minY, width: contentView.bounds.width, height: slice.height)
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
    
        // if there is a mismatch between what the table thinks and what we display, reload to get accurate height
        if believedHeight != sizes.cellHeight,
            let indexPath = reloadIndexPath {
            if believedHeight == 0 {
                believedHeight = sizes.cellHeight
            } else {
                form_tableView()?.reloadRows(at: [indexPath], with: .none)
            }
        }

		var textViewInset = contentView.layoutMargins
		textViewInset.top = 5
		textViewInset.bottom = 10
		textView.textContainerInset = textViewInset
    
	}

	// MARK: UIResponder

	public override var canBecomeFirstResponder: Bool {
		true
	}

	public override func becomeFirstResponder() -> Bool {
		textView.becomeFirstResponder()
	}

	public override func resignFirstResponder() -> Bool {
		textView.resignFirstResponder()
	}
    
    public func assignDefaultColors() {
        textView.textColor = model.titleTextColor
    }
    
    public func assignTintColors() {
        textView.textColor = tintColor
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
        believedHeight = value
        reloadIndexPath = indexPath
		//SwiftyFormLog("compute height of row: \(value)")
		return value
	}
    
}
