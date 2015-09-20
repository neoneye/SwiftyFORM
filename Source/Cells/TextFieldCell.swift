// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit


public class CustomTextField: UITextField {
	
	public func configure() {
		backgroundColor = UIColor.whiteColor()
		autocapitalizationType = .Sentences
		autocorrectionType = .Default
		spellCheckingType = .No
		returnKeyType = .Done
		clearButtonMode = .WhileEditing
	}
	
}


public enum TextCellState {
	case NoMessage
	case TemporaryMessage(message: String)
	case PersistentMessage(message: String)
}


public class TextFieldFormItemCellSizes {
	public let titleLabelFrame: CGRect
	public let textFieldFrame: CGRect
	public let errorLabelFrame: CGRect
	public let cellHeight: CGFloat
	
	public init(titleLabelFrame: CGRect, textFieldFrame: CGRect, errorLabelFrame: CGRect, cellHeight: CGFloat) {
		self.titleLabelFrame = titleLabelFrame
		self.textFieldFrame = textFieldFrame
		self.errorLabelFrame = errorLabelFrame
		self.cellHeight = cellHeight
	}
}

public struct TextFieldFormItemCellModel {
	var title: String = ""
	var toolbarMode: ToolbarMode = .Simple
	var placeholder: String = ""
	var keyboardType: UIKeyboardType = .Default
	var returnKeyType: UIReturnKeyType = .Default
	var autocorrectionType: UITextAutocorrectionType = .No
	var autocapitalizationType: UITextAutocapitalizationType = .None
	var spellCheckingType: UITextSpellCheckingType = .No
	var secureTextEntry = false
	var model: TextFieldFormItem! = nil

	var valueDidChange: String -> Void = { (value: String) in
		DLog("value \(value)")
	}
}

public class TextFieldFormItemCell: UITableViewCell, UITextFieldDelegate, CellHeightProvider {
	public let model: TextFieldFormItemCellModel
	public let titleLabel = UILabel()
	public let textField = CustomTextField()
	public let errorLabel = UILabel()
	
	public var state: TextCellState = .NoMessage
	
	public init(model: TextFieldFormItemCellModel) {
		self.model = model
		super.init(style: .Default, reuseIdentifier: nil)

		self.addGestureRecognizer(tapGestureRecognizer)
		
		selectionStyle = .None
		
		titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		textField.font  = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		errorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
		
		errorLabel.textColor = UIColor.redColor()
		errorLabel.numberOfLines = 0
		
		textField.configure()
		textField.delegate = self
		
		textField.addTarget(self, action: "valueDidChange:", forControlEvents: UIControlEvents.EditingChanged)
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(textField)
		contentView.addSubview(errorLabel)

		titleLabel.text = model.title
		textField.placeholder = model.placeholder
		textField.autocapitalizationType = model.autocapitalizationType
		textField.autocorrectionType = model.autocorrectionType
		textField.keyboardType = model.keyboardType
		textField.returnKeyType = model.returnKeyType
		textField.spellCheckingType = model.spellCheckingType
		textField.secureTextEntry = model.secureTextEntry
		
		if self.model.toolbarMode == .Simple {
			textField.inputAccessoryView = toolbar
		}
		
		updateErrorLabel(model.model.liveValidateValueText())

//		titleLabel.backgroundColor = UIColor.blueColor()
//		textField.backgroundColor = UIColor.greenColor()
//		errorLabel.backgroundColor = UIColor.yellowColor()
		clipsToBounds = true
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
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
	
	public func handleTap(sender: UITapGestureRecognizer) {
		textField.becomeFirstResponder()
	}
	
	public lazy var tapGestureRecognizer: UITapGestureRecognizer = {
		let gr = UITapGestureRecognizer(target: self, action: "handleTap:")
		return gr
		}()
	
	public enum TitleWidthMode {
		case Auto
		case Assign(width: CGFloat)
	}
	
	public var titleWidthMode: TitleWidthMode = .Auto
	
	public func compute(cellWidth: CGFloat) -> TextFieldFormItemCellSizes {

		var titleLabelFrame = CGRectZero
		var textFieldFrame = CGRectZero
		var errorLabelFrame = CGRectZero
		var cellHeight: CGFloat = 0
		let veryTallCell = CGRectMake(0, 0, cellWidth, CGFloat.max)
		let area = veryTallCell.insetBy(dx: 16, dy: 0)
		
		let (topRect, _) = area.divide(44, fromEdge: .MinYEdge)
		if true {
			let size = titleLabel.sizeThatFits(area.size)
			var titleLabelWidth = size.width
			
			switch titleWidthMode {
			case .Auto:
				break
			case let .Assign(width):
				let w = CGFloat(width)
				if w > titleLabelWidth {
					titleLabelWidth = w
				}
			}

			var (slice, remainder) = topRect.divide(titleLabelWidth, fromEdge: .MinXEdge)
			titleLabelFrame = slice
			(_, remainder) = remainder.divide(10, fromEdge: .MinXEdge)
			remainder.size.width += 4
			textFieldFrame = remainder

			cellHeight = ceil(textFieldFrame.height)
		}
		if true {
			let size = errorLabel.sizeThatFits(area.size)
//			DLog("error label size \(size)")
			if size.height > 0.1 {
				var r = topRect
				r.origin.y = topRect.maxY - 6
				let (slice, _) = r.divide(size.height, fromEdge: .MinYEdge)
				errorLabelFrame = slice
				cellHeight = ceil(errorLabelFrame.maxY + 10)
			}
		}
		
		return TextFieldFormItemCellSizes(titleLabelFrame: titleLabelFrame, textFieldFrame: textFieldFrame, errorLabelFrame: errorLabelFrame, cellHeight: cellHeight)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		//DLog("layoutSubviews")
		let sizes: TextFieldFormItemCellSizes = compute(bounds.width)
		titleLabel.frame = sizes.titleLabelFrame
		textField.frame = sizes.textFieldFrame
		errorLabel.frame = sizes.errorLabelFrame
	}
	
	public func valueDidChange(sender: AnyObject?) {
		//DLog("did change")
		model.valueDidChange(textField.text ?? "")
		
		let result: ValidateResult = model.model.liveValidateValueText()
		switch result {
		case .Valid:
			DLog("valid")
		case .HardInvalid:
			DLog("hard invalid")
		case .SoftInvalid:
			DLog("soft invalid")
		}
	}

	public func setValueWithoutSync(value: String) {
		DLog("set value \(value)")
		textField.text = value
		validateAndUpdateErrorIfNeeded(value, shouldInstallTimer: false, checkSubmitRule: false)
	}
	

	// Hide the keyboard when the user taps the return key in this UITextField
	public func textFieldShouldReturn(textField: UITextField) -> Bool {
		let s = textField.text ?? ""
		let isTextValid = validateAndUpdateErrorIfNeeded(s, shouldInstallTimer: true, checkSubmitRule: true)
		if isTextValid {
			textField.resignFirstResponder()
		}
		return false
	}
	
	public func updateErrorLabel(result: ValidateResult) {
		switch result {
		case .Valid:
			errorLabel.text = nil
		case .HardInvalid(let message):
			errorLabel.text = message
		case .SoftInvalid(let message):
			errorLabel.text = message
		}
	}
	
	public var lastResult: ValidateResult?
	
	public var hideErrorMessageAfterFewSecondsTimer: NSTimer?
	public func invalidateTimer() {
		if let timer = hideErrorMessageAfterFewSecondsTimer {
			timer.invalidate()
			hideErrorMessageAfterFewSecondsTimer = nil
		}
	}
	
	public func installTimer() {
		invalidateTimer()
		let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "timerUpdate", userInfo: nil, repeats: false)
		hideErrorMessageAfterFewSecondsTimer = timer
	}
	
	// Returns true  when valid
	// Returns false when invalid
	public func validateAndUpdateErrorIfNeeded(text: String, shouldInstallTimer: Bool, checkSubmitRule: Bool) -> Bool {
		
		let tableView: UITableView? = form_tableView()

		let result: ValidateResult = model.model.validateText(text, checkHardRule: true, checkSoftRule: true, checkSubmitRule: checkSubmitRule)
		if let lastResult = lastResult {
			if lastResult == result {
				switch result {
				case .Valid:
					//DLog("same valid")
					return true
				case .HardInvalid:
					//DLog("same hard invalid")
					invalidateTimer()
					if shouldInstallTimer {
						installTimer()
					}
					return false
				case .SoftInvalid:
					//DLog("same soft invalid")
					invalidateTimer()
					if shouldInstallTimer {
						installTimer()
					}
					return true
				}
			}
		}
		lastResult = result
		
		switch result {
		case .Valid:
			//DLog("different valid")
			if let tv = tableView {
				tv.beginUpdates()
				errorLabel.text = nil
				setNeedsLayout()
				tv.endUpdates()
				
				invalidateTimer()
			}
			return true
		case let .HardInvalid(message):
			//DLog("different hard invalid")
			if let tv = tableView {
				tv.beginUpdates()
				errorLabel.text = message
				setNeedsLayout()
				tv.endUpdates()
				
				invalidateTimer()
				if shouldInstallTimer {
					installTimer()
				}
			}
			return false
		case let .SoftInvalid(message):
			//DLog("different soft invalid")
			if let tv = tableView {
				tv.beginUpdates()
				errorLabel.text = message
				setNeedsLayout()
				tv.endUpdates()
				
				invalidateTimer()
				if shouldInstallTimer {
					installTimer()
				}
			}
			return true
		}
	}

	public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		let textFieldString: NSString = textField.text ?? ""
		let s = textFieldString.stringByReplacingCharactersInRange(range, withString:string)
		let valid = validateAndUpdateErrorIfNeeded(s, shouldInstallTimer: true, checkSubmitRule: false)
		return valid
	}
	
	public func timerUpdate() {
		invalidateTimer()
		//DLog("timer update")

		let s = textField.text ?? ""
		validateAndUpdateErrorIfNeeded(s, shouldInstallTimer: false, checkSubmitRule: false)
	}

	public func reloadPersistentValidationState() {
		invalidateTimer()
		//DLog("reload persistent message")

		let s = textField.text ?? ""
		validateAndUpdateErrorIfNeeded(s, shouldInstallTimer: false, checkSubmitRule: true)
	}

	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		let sizes: TextFieldFormItemCellSizes = compute(bounds.width)
		let value = sizes.cellHeight
		//DLog("compute height of row: \(value)")
		return value
	}
	
	public func textFieldDidBeginEditing(textField: UITextField) {
		updateToolbarButtons()
	}
	
	// MARK: UIResponder
	
	public override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	public override func becomeFirstResponder() -> Bool {
		return textField.becomeFirstResponder()
	}
	
	public override func resignFirstResponder() -> Bool {
		return textField.resignFirstResponder()
	}
	
}
