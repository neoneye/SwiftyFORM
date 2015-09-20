// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public class SimpleToolbar: UIToolbar {
	public var jumpToPrevious: Void -> Void = {}
	public var jumpToNext: Void -> Void = {}
	public var dismissKeyboard: Void -> Void = {}
	
	public init() {
		super.init(frame: CGRectZero)
		self.backgroundColor = UIColor.whiteColor()
		self.items = self.toolbarItems()
		self.autoresizingMask = [.FlexibleWidth, .FlexibleHeight, .FlexibleBottomMargin, .FlexibleTopMargin]
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public lazy var previousButton: UIBarButtonItem = {
		let image = UIImage(named: "SwiftFORMArrowLeft", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
		if let image = image {
			let image2 = image.imageWithRenderingMode(.AlwaysTemplate)
			return UIBarButtonItem(image: image2, style: .Plain, target: self, action: "previousButtonAction:")
		}
		return UIBarButtonItem(title: "<<", style: .Plain, target: self, action: "previousButtonAction:")
		}()
	
	public lazy var nextButton: UIBarButtonItem = {
		let image = UIImage(named: "SwiftFORMArrowRight", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
		if let image = image {
			let image2 = image.imageWithRenderingMode(.AlwaysTemplate)
			return UIBarButtonItem(image: image2, style: .Plain, target: self, action: "nextButtonAction:")
		}
		return UIBarButtonItem(title: ">>", style: .Plain, target: self, action: "nextButtonAction:")
		}()
	
	public lazy var closeButton: UIBarButtonItem = {
		let item = UIBarButtonItem(title: "OK", style: .Plain, target: self, action: "closeButtonAction:")
		return item
		}()
	
	public func toolbarItems() -> [UIBarButtonItem] {
		let spacer0 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
		spacer0.width = 15.0
		
		let spacer1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
		
		var items = [UIBarButtonItem]()
		items.append(previousButton)
		items.append(spacer0)
		items.append(nextButton)
		items.append(spacer1)
		items.append(closeButton)
		return items
	}
	
	public func previousButtonAction(sender: UIBarButtonItem!) {
		jumpToPrevious()
	}

	public func nextButtonAction(sender: UIBarButtonItem!) {
		jumpToNext()
	}
	
	public func closeButtonAction(sender: UIBarButtonItem!) {
		dismissKeyboard()
	}
	
	public func updateButtonConfiguration(cell: UITableViewCell) {
		previousButton.enabled = cell.form_canMakePreviousCellFirstResponder()
		nextButton.enabled = cell.form_canMakeNextCellFirstResponder()
	}
}
