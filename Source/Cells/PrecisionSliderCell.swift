// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public struct PrecisionSliderCellModel {
	var title: String = ""
	var value: Float = 0.0
	var minimumValue: Float = 0.0
	var maximumValue: Float = 1.0
	
	var valueDidChange: Float -> Void = { (value: Float) in
		SwiftyFormLog("value \(value)")
	}
}

public class PrecisionSliderCell: UITableViewCell, CellHeightProvider {
	public let model: PrecisionSliderCellModel

	public init(model: PrecisionSliderCellModel) {
		self.model = model
		super.init(style: .Default, reuseIdentifier: nil)
		selectionStyle = .None
		
		clipsToBounds = true
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		return 60
	}
}

public class PrecisionSliderCellExpanded: UITableViewCell, CellHeightProvider {

	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		return 160
	}
}
