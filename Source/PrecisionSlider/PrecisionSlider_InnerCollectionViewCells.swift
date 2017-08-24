// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

struct PrecisionSlider_InnerCollectionViewCellConstants {
	struct Label {
		static let topInset: CGFloat = 5
		static let height: CGFloat = 25
	}

	static let colorizeCells = false
}

/**
This cell displays a `mark` and displays a `label`.

The `label` is shown above the `mark`.

The `mark` is centered.
*/
class PrecisionSlider_InnerCollectionViewFullCell: UICollectionViewCell {
	static let identifier = "full_cell"

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	func commonInit() {
		addSubview(mark)
		addSubview(label)
	}

	lazy var mark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.black
		return instance
	}()

	lazy var label: UILabel = {
		let instance = UILabel()
		instance.textAlignment = .center
		instance.lineBreakMode = .byClipping
		instance.text = "0"
		return instance
	}()

	override func layoutSubviews() {
		super.layoutSubviews()
		let markX = floor(bounds.midX)
		mark.frame = CGRect(x: markX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 30)

		let (_, remain) = bounds.divided(atDistance: PrecisionSlider_InnerCollectionViewCellConstants.Label.topInset, from: .minYEdge)
		let (slice, _) = remain.divided(atDistance: PrecisionSlider_InnerCollectionViewCellConstants.Label.height, from: .minYEdge)
		label.frame = slice
	}
}

/**
This cell displays two markers, `partialMark` and `mark`, and displays a `label`.

The `label` is shown above the `mark`.

This kind of cell is twice as wide as a full_cell.

This cell is used when the minimumValue doesn't align with any marker.
In this case there is a little bit of air between the `partialMark` and the first `mark`.

This cell is not used when the minimumValue aligns perfectly to a marker.
In that case a full_cell is used.
*/
class PrecisionSlider_InnerCollectionViewFirstCell: UICollectionViewCell {
	static let identifier = "first_cell"

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	func commonInit() {
		if PrecisionSlider_InnerCollectionViewCellConstants.colorizeCells {
			backgroundColor = UIColor.green
		}
		addSubview(mark)
		addSubview(partialMark)
		addSubview(label)
	}

	lazy var mark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.black
		return instance
	}()

	lazy var partialMark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.black
		return instance
	}()

	lazy var label: UILabel = {
		let instance = UILabel()
		instance.textAlignment = .center
		instance.lineBreakMode = .byClipping
		instance.text = "0"
		return instance
	}()

	fileprivate var partialLength: Double = 0.0
	fileprivate var fullLength: Double = 0.0

	func configure(partialLength: Double, fullLength: Double) {
		self.partialLength = partialLength
		self.fullLength = fullLength
		setNeedsLayout()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		let markX = bounds.maxX - CGFloat(floor(fullLength / 2))
		mark.frame = CGRect(x: markX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 30)

		let partialMarkX = bounds.maxX - CGFloat(floor(fullLength / 2 + partialLength))
		partialMark.frame = CGRect(x: partialMarkX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 45)

		let (_, rightHalf) = bounds.divided(atDistance: CGFloat(fullLength), from: .minXEdge)
		let (_, remain) = rightHalf.divided(atDistance: PrecisionSlider_InnerCollectionViewCellConstants.Label.topInset, from: .minYEdge)
		let (slice, _) = remain.divided(atDistance: PrecisionSlider_InnerCollectionViewCellConstants.Label.height, from: .minYEdge)
		label.frame = slice
	}
}

/**
This cell displays two markers, `mark` and `partialMark`, and displays a `label`.

The `label` is shown above the `mark`.

This kind of cell is twice as wide as a full_cell.

This cell is used when the maximumValue doesn't align with any marker.
In this case there is a little bit of air between the last `mark` and the `partialMark`.

This cell is not used when the maxmimumValue aligns perfectly to a marker.
In that case a full_cell is used.
*/
class PrecisionSlider_InnerCollectionViewLastCell: UICollectionViewCell {
	static let identifier = "last_cell"

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	func commonInit() {
		if PrecisionSlider_InnerCollectionViewCellConstants.colorizeCells {
			backgroundColor = UIColor.red
		}
		addSubview(mark)
		addSubview(partialMark)
		addSubview(label)
	}

	lazy var mark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.black
		return instance
	}()

	lazy var partialMark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.black
		return instance
	}()

	lazy var label: UILabel = {
		let instance = UILabel()
		instance.textAlignment = .center
		instance.lineBreakMode = .byClipping
		instance.text = "0"
		return instance
	}()

	fileprivate var partialLength: Double = 0.0
	fileprivate var fullLength: Double = 0.0

	func configure(partialLength: Double, fullLength: Double) {
		self.partialLength = partialLength
		self.fullLength = fullLength
		setNeedsLayout()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		let markX = CGFloat(floor(fullLength / 2))
		mark.frame = CGRect(x: markX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 30)

		let partialMarkX = CGFloat(floor(fullLength / 2 + partialLength))
		partialMark.frame = CGRect(x: partialMarkX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 45)

		let (leftHalf, _) = bounds.divided(atDistance: CGFloat(fullLength), from: .minXEdge)
		let (_, remain) = leftHalf.divided(atDistance: PrecisionSlider_InnerCollectionViewCellConstants.Label.topInset, from: .minYEdge)
		let (slice, _) = remain.divided(atDistance: PrecisionSlider_InnerCollectionViewCellConstants.Label.height, from: .minYEdge)
		label.frame = slice
	}
}

/**
This cell displays two markers, `leftMark` and `rightMark`.

The `leftMark` indicates where the minimumValue is.
The `rightMark` indicates where the maximumValue is.

This cell is used when the content length is too narrow so there isn't any room for: full_cell, first_cell, last_cell
This cell is a last resort to show something meaningful.
*/
class PrecisionSlider_InnerCollectionViewSingleCell: UICollectionViewCell {
	static let identifier = "single_cell"

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	func commonInit() {
		if PrecisionSlider_InnerCollectionViewCellConstants.colorizeCells {
			backgroundColor = UIColor.blue
		}
		addSubview(leftMark)
		addSubview(rightMark)
	}

	lazy var leftMark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.black
		return instance
	}()

	lazy var rightMark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.black
		return instance
	}()

	override func layoutSubviews() {
		super.layoutSubviews()
		let insetBounds = bounds.insetBy(dx: 0, dy: 30)
		leftMark.frame  = insetBounds.divided(atDistance: 1, from: .minXEdge).slice
		rightMark.frame = insetBounds.divided(atDistance: 1, from: .maxXEdge).slice
	}
}
