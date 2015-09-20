// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

extension FormBuilder {
	public func demo_showInfo(text: String) {
		let headerView = SectionHeaderViewFormItem()
		headerView.viewBlock = {
			return InfoView(frame: CGRectMake(0, 0, 0, 100), text: text)
		}
		self.append(headerView)
	}
}

public class InfoView: UIView {
	public let label: UILabel
	
	public init(frame: CGRect, text: String) {
		self.label = UILabel()
		super.init(frame: frame)
		clipsToBounds = true
		self.addSubview(label)
		label.textColor = UIColor.darkGrayColor()
		label.text = text
		label.numberOfLines = 0
		label.textAlignment = .Center
		label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		let size = label.sizeThatFits(bounds.size)
		label.frame = CGRectMake(bounds.midX - size.width / 2, bounds.midY - size.height / 2, size.width, size.height)
	}
}
