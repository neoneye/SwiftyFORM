// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

open class SimpleToolbar: UIToolbar {
	open var jumpToPrevious: (Void) -> Void = {}
	open var jumpToNext: (Void) -> Void = {}
	open var dismissKeyboard: (Void) -> Void = {}
	
	public init() {
		super.init(frame: CGRect.zero)
		self.backgroundColor = UIColor.white
		self.items = self.toolbarItems()
		self.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin]
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open lazy var previousButton: UIBarButtonItem = {
		let image = UIImage(named: "SwiftFORMArrowLeft", in: Bundle(for: type(of: self)), compatibleWith: nil)
		if let image = image {
			let image2 = image.withRenderingMode(.alwaysTemplate)
			return UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(SimpleToolbar.previousButtonAction(_:)))
		}
		return UIBarButtonItem(title: "◀︎", style: .plain, target: self, action: #selector(SimpleToolbar.previousButtonAction(_:)))
		}()
	
	open lazy var nextButton: UIBarButtonItem = {
		let image = UIImage(named: "SwiftFORMArrowRight", in: Bundle(for: type(of: self)), compatibleWith: nil)
		if let image = image {
			let image2 = image.withRenderingMode(.alwaysTemplate)
			return UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(SimpleToolbar.nextButtonAction(_:)))
		}
		return UIBarButtonItem(title: "▶", style: .plain, target: self, action: #selector(SimpleToolbar.nextButtonAction(_:)))
		}()
	
	open lazy var closeButton: UIBarButtonItem = {
		let item = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(SimpleToolbar.closeButtonAction(_:)))
		return item
		}()
	
	open func toolbarItems() -> [UIBarButtonItem] {
		let spacer0 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
		spacer0.width = 15.0
		
		let spacer1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		var items = [UIBarButtonItem]()
		items.append(previousButton)
		items.append(spacer0)
		items.append(nextButton)
		items.append(spacer1)
		items.append(closeButton)
		return items
	}
	
	open func previousButtonAction(_ sender: UIBarButtonItem!) {
		jumpToPrevious()
	}

	open func nextButtonAction(_ sender: UIBarButtonItem!) {
		jumpToNext()
	}
	
	open func closeButtonAction(_ sender: UIBarButtonItem!) {
		dismissKeyboard()
	}
	
	open func updateButtonConfiguration(_ cell: UITableViewCell) {
		previousButton.isEnabled = cell.form_canMakePreviousCellFirstResponder()
		nextButton.isEnabled = cell.form_canMakeNextCellFirstResponder()
	}
}
