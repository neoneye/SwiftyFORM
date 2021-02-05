// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit

/// `FormTableViewStyle` correspond to `UITableView.Style`
///
/// SwiftyFORM doesn't support the style `UITableView.Style.plain`.
/// Therefore it's left out, to prevent anyone from using it by accident.
public enum FormTableViewStyle {
    /// Correspond to `UITableView.Style.grouped`
    case grouped

    /// Correspond to `UITableView.Style.insetGrouped`
    @available(iOS 13.0, *)
    case insetGrouped
}

public class FormTableView: UITableView {

    public init(style: FormTableViewStyle) {

        /// SwiftyFORM does not support the style `UITableView.Style.plain`.
        /// It's only `.grouped` and `.insetGrouped` that is supported.
        let uiTableViewStyle: UITableView.Style
        switch style {
        case .grouped:
            uiTableViewStyle = .grouped
        case .insetGrouped:
            if #available(iOS 13.0, *) {
                uiTableViewStyle = .insetGrouped
            } else {
                // Fallback on earlier versions
                uiTableViewStyle = .grouped
            }
        }

        super.init(frame: CGRect.zero, style: uiTableViewStyle)
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
