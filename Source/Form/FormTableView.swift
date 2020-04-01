// MIT license. Copyright (c) 2020 SwiftyFORM. All rights reserved.
import UIKit

public class FormTableView: UITableView {
    
    public init(style: UITableView.Style) {
		super.init(frame: CGRect.zero, style: style)
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
