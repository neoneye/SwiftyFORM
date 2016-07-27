// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

/*
one-finger pan to adjust slider
two-finger pinch to adjust zoom
*/
class PrecisionSlider: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
	struct Constants {
		static let alternatingBackgroundColors = false
	}
	
	var originalScale: Double = 1.0
	var originalValue: Double?
	
	var model = PrecisionSlider_InnerModel()
	
	typealias ValueDidChange = Void -> Void
	var valueDidChange: ValueDidChange?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		addSubview(collectionView)
		addSubview(leftCoverView)
		addSubview(rightCoverView)
		addGestureRecognizer(pinchGestureRecognizer)
	}
	
	func updateContentInset() {
		let halfWidth = round(bounds.width/2)
		let inset = halfWidth - round(CGFloat(model.lengthOfFullItem) / 2)
		var insetLeft = inset
		var insetRight = inset
		if model.hasPartialItemBefore {
			insetLeft = halfWidth - CGFloat(model.lengthOfFullItem / 2 + model.remainingLengthOfPartialItemBefore)
		}
		if model.hasPartialItemAfter {
			insetRight = halfWidth - CGFloat(model.lengthOfFullItem / 2 + model.remainingLengthOfPartialItemAfter)
		}
		collectionView.contentInset = UIEdgeInsets(top: 0, left: insetLeft, bottom: 0, right: insetRight)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		collectionView.frame = bounds
		
		updateContentInset()
		
		let (leftFrame, rightFrame) = bounds.divide(round(bounds.width/2), fromEdge: .MinXEdge)
		leftCoverView.frame = CGRect(x: leftFrame.origin.x, y: leftFrame.origin.y, width: leftFrame.size.width - 1, height: leftFrame.size.height)
		rightCoverView.frame = rightFrame
	}
	
	lazy var leftCoverView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
		instance.userInteractionEnabled = false
		return instance
	}()
	
	lazy var rightCoverView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
		instance.userInteractionEnabled = false
		return instance
	}()
	
	var value: Double? {
		let scale = model.lengthOfFullItem
		if scale < 0.1 {
			return nil
		}
		
		let midX: CGFloat = collectionView.contentOffset.x + collectionView.contentInset.left
		var result = Double(midX) / scale + model.minimumValue
		if result < model.minimumValue {
			result = model.minimumValue
		}
		if result > model.maximumValue {
			result = model.maximumValue
		}
		result /= Double(model.markers)
		return result
	}
	
	func setValue(value: Double, animated: Bool) {
		let scale = model.lengthOfFullItem
		if scale < 0.1 {
			return
		}
		
		var clampedValue = value * Double(model.markers)
		if clampedValue < model.minimumValue {
			clampedValue = model.minimumValue
		}
		if clampedValue > model.maximumValue {
			clampedValue = model.maximumValue
		}
		
		let valueAdjusted = clampedValue - model.minimumValue
		let contentInsetLet = Double(collectionView.contentInset.left)
		let offsetX = CGFloat(round((scale * valueAdjusted) - contentInsetLet))
		//print("offsetX: \(offsetX)    [ \(scale) * \(valueAdjusted) - \(contentInsetLet) ]")
		
		let originalValueDidChange = valueDidChange
		valueDidChange = nil
		collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
		valueDidChange = originalValueDidChange
	}
	
	lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
		let instance = UIPinchGestureRecognizer(target: self, action: #selector(PrecisionSlider.handlePinch))
		instance.delegate = self
		return instance
	}()
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	func handlePinch(gesture: UIPinchGestureRecognizer) {
		if gesture.state == .Began {
			originalScale = model.scale
			originalValue = self.value
		}
		if gesture.state == .Changed {
			var scale = originalScale * Double(gesture.scale)
			if scale < 0.0 {
				scale = 0.01
			}
			model.scale = scale
//			let markersBefore = model.markers
			model.updateRange()
//			let markersAfter = model.markers
			updateContentInset()
			
//			if markersBefore != markersAfter {
				collectionView.reloadData()
//			}
			
			layout.itemSize = computeItemSize()
			layout.invalidateLayout()
			
			if let value = originalValue {
				setValue(value, animated: false)
			}
			
			valueDidChange?()
		}
	}
	
	func computeItemSize() -> CGSize {
		return CGSize(width: CGFloat(model.lengthOfFullItem), height: PrecisionSlider_InnerModel.height)
	}
	
	lazy var layout: PrecisionSlider_InnerCollectionViewFlowLayout = {
		let instance = PrecisionSlider_InnerCollectionViewFlowLayout()
		instance.scrollDirection = .Horizontal
		instance.minimumInteritemSpacing = 0
		instance.minimumLineSpacing = 0
		instance.sectionInset = UIEdgeInsetsZero
		instance.headerReferenceSize = CGSizeZero
		instance.footerReferenceSize = CGSizeZero
		instance.itemSize = self.computeItemSize()
		instance.model = self.model
		return instance
	}()
	
	lazy var collectionView: UICollectionView = {
		let instance = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
		instance.showsHorizontalScrollIndicator = false
		instance.showsVerticalScrollIndicator = false
		instance.backgroundColor = UIColor.whiteColor()
		instance.bounces = false
		instance.alwaysBounceHorizontal = true
		instance.alwaysBounceVertical = false
		instance.registerClass(PrecisionSlider_InnerCollectionViewFirstCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewFirstCell.identifier)
		instance.registerClass(PrecisionSlider_InnerCollectionViewLastCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewLastCell.identifier)
		instance.registerClass(PrecisionSlider_InnerCollectionViewCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewCell.identifier)
		instance.contentInset = UIEdgeInsetsZero
		instance.delegate = self
		instance.dataSource = self
		return instance
	}()
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		valueDidChange?()
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		var count = model.numberOfFullItems
		if model.hasOnePartialItem {
			count += 1
		}
		if model.hasPartialItemBefore {
			count += 1
		}
		if model.hasPartialItemAfter {
			count += 1
		}
		//print("number of items: \(count)")
		return count
	}
	
	func labelTextForIndexPath(indexPath: NSIndexPath) -> String? {
		var index = Int(floor(model.minimumValue)) + indexPath.row
		if model.hasPartialItemBefore {
			index += 1
		}
		if model.markers == 1 {
			let displayValue = index % 10
			return String(displayValue)
		}
		if model.markers == 2 {
			if index % 2 != 0 {
				return nil
			}
			let adjustedIndex = index / 2
			let displayValue = adjustedIndex % 10
			return String(displayValue)
		}
		if model.markers == 10 {
			if index % 10 != 0 {
				return nil
			}
			let adjustedIndex = index / 10
			let displayValue = adjustedIndex % 10
			return String(displayValue)
		}
		if model.markers == 20 {
			if index % 20 != 0 {
				return nil
			}
			let adjustedIndex = index / 20
			let displayValue = adjustedIndex % 10
			return String(displayValue)
		}
		return nil
	}

	func markColorForIndexPath(indexPath: NSIndexPath) -> UIColor? {
		var index = Int(floor(model.minimumValue)) + indexPath.row
		if model.hasPartialItemBefore {
			index += 1
		}
		if model.markers == 1 {
			return UIColor.blackColor()
		}
		if model.markers == 2 {
			if index % 2 == 0 {
				return UIColor.blackColor()
			} else {
				return UIColor(white: 0.7, alpha: 1.0)
			}
		}
		if model.markers == 10 {
			if index % 10 == 0 {
				return UIColor.blackColor()
			}
			if abs(index % 10) == 5 {
				return UIColor.blackColor()
			} else {
				return UIColor(white: 0.7, alpha: 1.0)
			}
		}
		if model.markers == 20 {
			if index % 2 == 0 {
				return UIColor.blackColor()
			} else {
				return UIColor(white: 0.7, alpha: 1.0)
			}
		}
		return nil
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let labelText: String? = labelTextForIndexPath(indexPath)
		let markColor: UIColor? = markColorForIndexPath(indexPath)
		
		let count = self.collectionView(collectionView, numberOfItemsInSection: 0)
		let isFirst = indexPath.row == 0
		let isLast = indexPath.row == count - 1
		
		if isFirst && model.hasPartialItemBefore {
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PrecisionSlider_InnerCollectionViewFirstCell.identifier, forIndexPath: indexPath) as! PrecisionSlider_InnerCollectionViewFirstCell
			cell.label.text = labelText
			cell.mark.backgroundColor = markColor
			cell.configure(model.lengthOfPartialItemBefore, fullLength: model.lengthOfFullItem)
			return cell
		}
		if isLast && model.hasPartialItemAfter {
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PrecisionSlider_InnerCollectionViewLastCell.identifier, forIndexPath: indexPath) as! PrecisionSlider_InnerCollectionViewLastCell
			cell.label.text = labelText
			cell.mark.backgroundColor = markColor
			cell.configure(model.lengthOfPartialItemAfter, fullLength: model.lengthOfFullItem)
			return cell
		}
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PrecisionSlider_InnerCollectionViewCell.identifier, forIndexPath: indexPath) as! PrecisionSlider_InnerCollectionViewCell
		cell.label.text = labelText
		cell.mark.backgroundColor = markColor

		if Constants.alternatingBackgroundColors {
			let index = Int(floor(model.minimumValue)) + indexPath.row
			if index % 2 == 0 {
				cell.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 0.9, alpha: 1.0)
			} else {
				cell.backgroundColor = UIColor(red: 0.4, green: 0.9, blue: 0.9, alpha: 1.0)
			}
		}
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		if model.hasOnePartialItem {
			let size = CGSize(
				width: CGFloat(model.lengthOfOnePartialItem),
				height: PrecisionSlider_InnerModel.height
			)
			//print("size for one-partial \(indexPath.row) \(size.width)")
			return size
		}
		var row = indexPath.row
		if model.hasPartialItemBefore {
			if row == 0 {
				let size = CGSize(
					width: CGFloat(model.lengthOfFullItem * 2),
					height: PrecisionSlider_InnerModel.height
				)
				//print("size for partial-before \(indexPath.row) \(size.width)")
				return size
			}
			row -= 1
		}
		if row >= model.numberOfFullItems {
			if model.hasPartialItemAfter {
				let size = CGSize(
					width: CGFloat(model.lengthOfFullItem * 2),
					height: PrecisionSlider_InnerModel.height
				)
				//print("size for partial-after \(indexPath.row) \(size.width)")
				return size
			}
		}
		let size = CGSize(
			width: CGFloat(model.lengthOfFullItem),
			height: PrecisionSlider_InnerModel.height
		)
		//print("size for full \(indexPath.row) \(size.width)")
		return size
	}
}


// MARK: - Classes used internally by PrecisionSlider

class PrecisionSlider_InnerModel: CustomDebugStringConvertible {
	var minimumValue: Double = 0.0
	var maximumValue: Double = 100.0
	
	var originalMaximumValue: Double = 0.0
	var originalMinimumValue: Double = 100.0
	
	var markers = 1
	
	func updateRange() {
		if scale > 800 {
			markers = 20
		} else {
			if scale > 250 {
				markers = 10
			} else {
				if scale > 100 {
					markers = 2
				} else {
					markers = 1
				}
			}
		}
//		print("!!!!!!!! \(markers)  \(scale)")
		
		maximumValue = originalMaximumValue * Double(markers)
		minimumValue = originalMinimumValue * Double(markers)
		
		let count = Int(floor(maximumValue) - ceil(minimumValue))
		if count < 0 {
			//print("partial item that doesn't cross a integer boundary. maximumValue=\(maximumValue)  minimumValue=\(minimumValue)")
			numberOfFullItems = 0
			hasOnePartialItem = true
			sizeOfOnePartialItem = maximumValue - minimumValue
			hasPartialItemBefore = false
			sizeOfPartialItemBefore = 0
			hasPartialItemAfter = false
			sizeOfPartialItemAfter = 0
			return
		}
		numberOfFullItems = count + 1
		
		let sizeBefore = ceil(minimumValue) - minimumValue
		//print("size before: \(sizeBefore)    \(minimumValue)")
		if sizeBefore > 0.0000001 {
			//print("partial item before. size: \(sizeBefore)   minimumValue: \(minimumValue)")
			hasPartialItemBefore = true
			sizeOfPartialItemBefore = sizeBefore
			numberOfFullItems -= 1
		} else {
			hasPartialItemBefore = false
			sizeOfPartialItemBefore = 0
		}
		
		let sizeAfter = maximumValue - floor(maximumValue)
		//print("size after: \(sizeAfter)    \(maximumValue)")
		if sizeAfter > 0.0000001 {
			//print("partial item after. size: \(sizeAfter)   minimumValue: \(maximumValue)")
			hasPartialItemAfter = true
			sizeOfPartialItemAfter = sizeAfter
			numberOfFullItems -= 1
		} else {
			hasPartialItemAfter = false
			sizeOfPartialItemAfter = 0
		}
		
		// TODO: deal with negative number of full items
		
//		print("model: \(self)")
	}
	
	/*
	This is used when the range is tiny and doesn't cross any integer boundary.
	Example of such a range: from min=0.4 to max=0.6
	here the size of the range is 0.2, which is (max - min)
	*/
	var hasOnePartialItem = false
	var sizeOfOnePartialItem: Double = 0.0
	
	/*
	This is used when the range-start crosses an integer boundary.
	Example of such a range: from min=0.7 to max=3.3
	In this case there will be a partial-item-before
	with the range from min=0.7 to max=1.0
	here the size of the range is 0.3  (max - min)
	*/
	var hasPartialItemBefore = false
	var sizeOfPartialItemBefore: Double = 0.0
	
	/*
	This is used when the range is crossing zero or more integer boundaries.
	Example of such a range: from min=0.7 to max=3.3
	In this case there will be a full items will span from min=1.0 to max=3.0
	here the number of full items is 2  (max - min)
	The size of a full item is alway 1, since it's full.
	*/
	var numberOfFullItems = 100
	
	/*
	This is used when the range-end crosses an integer boundary.
	Example of such a range: from min=0.7 to max=3.3
	In this case there will be a partial-item-after
	with the range from min=3.0 to max=3.3
	here the size of the range is 0.3  (max - min)
	*/
	var hasPartialItemAfter = false
	var sizeOfPartialItemAfter: Double = 0.0
	
	var scale: Double = 60.0
	
	var lengthOfFullItem: Double {
		let result = ceil(scale / Double(markers))
		if result < 0.1 {
			return 0.1
		}
		return result
	}
	
	var lengthOfAllFullItems: Double {
		return Double(numberOfFullItems) * lengthOfFullItem
	}
	var lengthOfOnePartialItem: Double {
		return ceil(lengthOfFullItem * sizeOfOnePartialItem)
	}
	var lengthOfPartialItemBefore: Double {
		return ceil(lengthOfFullItem * sizeOfPartialItemBefore)
	}
	var remainingLengthOfPartialItemBefore: Double {
		return ceil(lengthOfFullItem * (1.0 - sizeOfPartialItemBefore))
	}
	var lengthOfPartialItemAfter: Double {
		return ceil(lengthOfFullItem * sizeOfPartialItemAfter)
	}
	var remainingLengthOfPartialItemAfter: Double {
		return ceil(lengthOfFullItem * (1.0 - sizeOfPartialItemAfter))
	}
	
	var lengthOfContent: Double {
		var length: Double = 0
		if hasOnePartialItem {
			length += lengthOfOnePartialItem
		}
		if hasPartialItemBefore {
			length += lengthOfFullItem * 2
		}
		length += lengthOfAllFullItems
		if hasPartialItemAfter {
			length += lengthOfFullItem * 2
		}
		return length
	}
	
	static let height: CGFloat = 130
	
	var debugDescription: String {
		var strings = [String]()
		strings.append("markers: \(markers)")
		strings.append(String(format: "scale: %.5f", scale))
		strings.append(String(format: "range: %.5f %.5f", minimumValue, maximumValue))
		if hasOnePartialItem {
			strings.append(String(format: "one-partial: %.5f", sizeOfOnePartialItem))
		}
		if hasPartialItemBefore {
			strings.append(String(format: "partial-before: %.5f", sizeOfPartialItemBefore))
		}
		strings.append("full: \(numberOfFullItems)")
		if hasPartialItemAfter {
			strings.append(String(format: "partial-after: %.5f", sizeOfPartialItemAfter))
		}
		return strings.joinWithSeparator(" , ")
	}
}

class PrecisionSlider_InnerCollectionViewFlowLayout: UICollectionViewFlowLayout {
	weak var model: PrecisionSlider_InnerModel?
	
	override func collectionViewContentSize() -> CGSize {
		guard let model = self.model else {
			print("no model")
			return CGSizeZero
		}
		return CGSize(width: CGFloat(model.lengthOfContent), height: PrecisionSlider_InnerModel.height)
	}
}

class PrecisionSlider_InnerCollectionViewCell: UICollectionViewCell {
	static let identifier = "cell"
	
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
		instance.backgroundColor = UIColor.blackColor()
		return instance
	}()
	
	lazy var label: UILabel = {
		let instance = UILabel()
		instance.text = "0"
		return instance
	}()
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let markX = floor(bounds.midX)
		mark.frame = CGRect(x: markX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 30)
		
//		let labelHidden = self.bounds.width < 30
//		label.hidden = labelHidden
		
		label.sizeToFit()
		let labelFrame = label.frame
		let labelX = round(markX - labelFrame.width / 2)
		label.frame = CGRect(x: labelX, y: 5, width: labelFrame.width, height: labelFrame.height)
	}
}

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
		backgroundColor = UIColor.greenColor()
		addSubview(mark)
		addSubview(partialMark)
		addSubview(label)
	}
	
	lazy var mark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.blackColor()
		return instance
	}()
	
	lazy var partialMark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.blackColor()
		return instance
	}()
	
	lazy var label: UILabel = {
		let instance = UILabel()
		instance.text = "0"
		return instance
	}()
	
	private var partialLength: Double = 0.0
	private var fullLength: Double = 0.0
	
	func configure(partialLength: Double, fullLength: Double) {
		self.partialLength = partialLength
		self.fullLength = fullLength
		setNeedsLayout()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let markX = bounds.maxX - CGFloat(floor(fullLength / 2))
		mark.frame = CGRect(x: markX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 30)
		
		let labelHidden = self.bounds.width < 30
		label.hidden = labelHidden
		
		label.sizeToFit()
		let labelFrame = label.frame
		let labelX = round(markX - labelFrame.width / 2)
		label.frame = CGRect(x: labelX, y: 5, width: labelFrame.width, height: labelFrame.height)
		
		let partialMarkX = bounds.maxX - CGFloat(floor(fullLength / 2 + partialLength))
		partialMark.frame = CGRect(x: partialMarkX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 45)
	}
}

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
		backgroundColor = UIColor.redColor()
		addSubview(mark)
		addSubview(partialMark)
		addSubview(label)
	}
	
	lazy var mark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.blackColor()
		return instance
	}()
	
	lazy var partialMark: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.blackColor()
		return instance
	}()
	
	lazy var label: UILabel = {
		let instance = UILabel()
		instance.text = "0"
		return instance
	}()
	
	private var partialLength: Double = 0.0
	private var fullLength: Double = 0.0
	
	func configure(partialLength: Double, fullLength: Double) {
		self.partialLength = partialLength
		self.fullLength = fullLength
		setNeedsLayout()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let markX = CGFloat(floor(fullLength / 2))
		mark.frame = CGRect(x: markX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 30)
		
		let labelHidden = self.bounds.width < 30
		label.hidden = labelHidden
		
		label.sizeToFit()
		let labelFrame = label.frame
		let labelX = round(markX - labelFrame.width / 2)
		label.frame = CGRect(x: labelX, y: 5, width: labelFrame.width, height: labelFrame.height)
		
		let partialMarkX = CGFloat(floor(fullLength / 2 + partialLength))
		partialMark.frame = CGRect(x: partialMarkX, y: 0, width: 1, height: bounds.height).insetBy(dx: 0, dy: 45)
	}
}
