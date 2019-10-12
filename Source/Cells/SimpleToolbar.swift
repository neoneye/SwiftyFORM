// MIT license. Copyright (c) 2018 SwiftyFORM. All rights reserved.
import UIKit

public class SimpleToolbar: UIToolbar {
	public var jumpToPrevious: () -> Void = {}
	public var jumpToNext: () -> Void = {}
	public var dismissKeyboard: () -> Void = {}

	public init() {
		super.init(frame: CGRect.zero)
        self.backgroundColor = Colors.background
		self.items = self.toolbarItems()
		self.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin]
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public lazy var previousButton: UIBarButtonItem = {
		UIBarButtonItem(title: "◀︎", style: .plain, target: self, action: #selector(SimpleToolbar.previousButtonAction(_:)))
    }()

	public lazy var nextButton: UIBarButtonItem = {
		UIBarButtonItem(title: "▶", style: .plain, target: self, action: #selector(SimpleToolbar.nextButtonAction(_:)))
    }()

	public lazy var closeButton: UIBarButtonItem = {
		UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(SimpleToolbar.closeButtonAction(_:)))
    }()

	public func toolbarItems() -> [UIBarButtonItem] {
		let spacer0 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
		spacer0.width = 15.0

		let spacer1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

		var items = [UIBarButtonItem]()
		items.append(previousButton)
		items.append(spacer0)
		items.append(nextButton)
		items.append(spacer1)
		items.append(closeButton)
		return items
	}

	@objc public func previousButtonAction(_ sender: UIBarButtonItem!) {
		jumpToPrevious()
	}

	@objc public func nextButtonAction(_ sender: UIBarButtonItem!) {
		jumpToNext()
	}

	@objc public func closeButtonAction(_ sender: UIBarButtonItem!) {
		dismissKeyboard()
	}

	public func updateButtonConfiguration(_ cell: UITableViewCell) {
		previousButton.isEnabled = cell.form_canMakePreviousCellFirstResponder()
		nextButton.isEnabled = cell.form_canMakeNextCellFirstResponder()
	}
}
