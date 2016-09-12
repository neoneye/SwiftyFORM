// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class FormTableView: UITableView {
	public init() {
		super.init(frame: CGRectZero, style: .Grouped)
		contentInset = UIEdgeInsetsZero
		scrollIndicatorInsets = UIEdgeInsetsZero
		
		// Enable "Self Sizing Cells"
		estimatedRowHeight = 44.0
		rowHeight = UITableViewAutomaticDimension
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
