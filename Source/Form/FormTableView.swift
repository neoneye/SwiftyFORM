// MIT license. Copyright (c) 2018 SwiftyFORM. All rights reserved.
import UIKit

public class FormTableView: UITableView {
	public init() {
		super.init(frame: CGRect.zero, style: .grouped)
		contentInset = UIEdgeInsets.zero
		scrollIndicatorInsets = UIEdgeInsets.zero

		// Enable "Self Sizing Cells"
		estimatedRowHeight = 44.0
		rowHeight = UITableView.automaticDimension
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
