// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

/**
PrecisionSlider

These gestures are available:

 1. One-finger pan to adjust value
 2. Two-finger pinch to adjust zoom
 3. Double-tap to x10 zoom
 4. Double-2finger-tap to x10 unzoom

*/
class PrecisionSlider: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
	var originalZoom: Float = 0
	var originalValue: Double = 0
	
	var model = PrecisionSlider_InnerModel()
	
	struct SliderDidChangeModel {
		let value: Double
		let valueUpdated: Bool
		let zoom: Float
		let zoomUpdated: Bool
	}
	
	typealias SliderDidChangeBlock = (changeModel: SliderDidChangeModel) -> Void
	var valueDidChange: SliderDidChangeBlock?
	
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
		addGestureRecognizer(oneTouchDoubleTapGestureRecognizer)
		addGestureRecognizer(twoTouchDoubleTapGestureRecognizer)
	}
	
	func updateContentInset() {
		let halfWidth = round(bounds.width/2)
		if model.hasOnePartialItem {
			collectionView.contentInset = UIEdgeInsets(top: 0, left: halfWidth, bottom: 0, right: halfWidth)
			return
		}
		let inset = halfWidth - round(CGFloat(model.lengthOfFullItem) / 2)
		var insetLeft = inset
		var insetRight = inset
		if model.hasPartialItemBefore {
			insetLeft = halfWidth - CGFloat(model.lengthOfFullItem / 2 + model.remainingLengthOfPartialItemBefore)
		}
		if model.hasPartialItemAfter {
			insetRight = halfWidth - CGFloat(model.lengthOfFullItem / 2 + model.remainingLengthOfPartialItemAfter)
		}
		/*
		Add pixels to left/right insets, in order to make the maximumValue reachable.
		Otherwise it's only possible to slide to a value very very close to maximumValue,
		however the last 0.001 may be missing, so you only get 0.999 and never quite reach 1.0
		*/
		insetLeft += 1
		insetRight += 1
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

	var enablePropagationCounter = 0
	
	func disablePropagation() {
		enablePropagationCounter -= 1
	}
	
	func enablePropagation() {
		enablePropagationCounter += 1
	}
	

	
	// MARK: Value get/set

	var value: Double {
		get { return valueFromContentOffset() }
		set { setContentOffset(newValue) }
	}
	
	func valueFromContentOffset() -> Double {
		let length = model.lengthOfFullItem
		if length < 0.001 {
			return model.fallbackValue
		}
		
		let midX: CGFloat = collectionView.contentOffset.x + collectionView.contentInset.left
		var result = Double(midX) / length + model.minimumValue
		result = model.clampValue(result)
		result /= model.zoomMode.scalar
		return result
	}
	
	/**
	Scroll the collectionview so that the center indicator is aligned with the value.
	*/
	func setContentOffset(value: Double) {
		let length = model.lengthOfFullItem
		if length < 0.001 {
			return
		}
		
		var clampedValue = value * model.zoomMode.scalar
		clampedValue = model.clampValue(clampedValue)
		
		let valueAdjusted = clampedValue - model.minimumValue
		let contentInsetLet = Double(collectionView.contentInset.left)
		let offsetX = CGFloat(round((length * valueAdjusted) - contentInsetLet))
		//print("offsetX: \(offsetX)    [ \(length) * \(valueAdjusted) - \(contentInsetLet) ]")

		collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
	}
	
	
	// MARK: pinch gesture for zoom in/out
	
	lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
		let instance = UIPinchGestureRecognizer(target: self, action: #selector(PrecisionSlider.handlePinch))
		instance.delegate = self
		return instance
	}()
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return false
	}
	
	func handlePinch(gesture: UIPinchGestureRecognizer) {
		if gesture.state == .Began {
			originalZoom = model.zoom
			originalValue = self.value
		}
		if gesture.state == .Changed {
			let zoom = Float(log10(pow(10, Double(originalZoom)) * Double(gesture.scale)))
			changeZoom(zoom: zoom, value: originalValue)
			
			let changeModel = SliderDidChangeModel(
				value: originalValue,
				valueUpdated: false,
				zoom: model.zoom,
				zoomUpdated: true
			)
			valueDidChange?(changeModel: changeModel)
		}
	}
	
	
	// MARK: one-finger double-tap for zoom in
	
	lazy var oneTouchDoubleTapGestureRecognizer: UITapGestureRecognizer = {
		let instance = UITapGestureRecognizer(target: self, action: #selector(PrecisionSlider.handleOneTouchDoubleTap))
		instance.numberOfTapsRequired = 2
		instance.numberOfTouchesRequired = 1
		return instance
	}()

	func handleOneTouchDoubleTap(gesture: UIPinchGestureRecognizer) {
		SwiftyFormLog("zoom in")
		let originalZoom = model.zoom
		let originalValue = self.value
		
		let zoom0 = originalZoom + 0.2
		let zoom1 = originalZoom + 0.4
		let zoom2 = originalZoom + 0.6
		let zoom3 = originalZoom + 0.8
		let zoom4 = originalZoom + 1.0

		let clampedZoom = model.clampZoom(zoom4)
		if model.zoom == clampedZoom {
			return // already zoomed in, no need to update UI
		}

		disablePropagation()
		changeZoom(zoom: zoom0, value: originalValue)

		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.08 * Float(NSEC_PER_SEC)))
		dispatch_after(delay, dispatch_get_main_queue()) {
			self.changeZoom(zoom: zoom1, value: originalValue)

			dispatch_after(delay, dispatch_get_main_queue()) {
				self.changeZoom(zoom: zoom2, value: originalValue)

				dispatch_after(delay, dispatch_get_main_queue()) {
					self.changeZoom(zoom: zoom3, value: originalValue)
					
					dispatch_after(delay, dispatch_get_main_queue()) {
						self.changeZoom(zoom: zoom4, value: originalValue)
						self.enablePropagation()

						let changeModel = SliderDidChangeModel(
							value: originalValue,
							valueUpdated: false,
							zoom: self.model.zoom,
							zoomUpdated: true
						)
						self.valueDidChange?(changeModel: changeModel)
					}
				}
			}
		}
	}
	
	
	// MARK: two-finger double-tap for zoom out
	
	lazy var twoTouchDoubleTapGestureRecognizer: UITapGestureRecognizer = {
		let instance = UITapGestureRecognizer(target: self, action: #selector(PrecisionSlider.handleTwoTouchDoubleTap))
		instance.numberOfTapsRequired = 2
		instance.numberOfTouchesRequired = 2
		return instance
	}()
	
	func handleTwoTouchDoubleTap(gesture: UIPinchGestureRecognizer) {
		SwiftyFormLog("zoom out")
		let originalZoom = model.zoom
		let originalValue = self.value
		
		let zoom0 = originalZoom - 0.2
		let zoom1 = originalZoom - 0.4
		let zoom2 = originalZoom - 0.6
		let zoom3 = originalZoom - 0.8
		let zoom4 = originalZoom - 1.0
		
		let clampedZoom = model.clampZoom(zoom4)
		if model.zoom == clampedZoom {
			return // already zoomed out, no need to update UI
		}
		
		disablePropagation()
		changeZoom(zoom: zoom0, value: originalValue)
		
		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.08 * Float(NSEC_PER_SEC)))
		dispatch_after(delay, dispatch_get_main_queue()) {
			self.changeZoom(zoom: zoom1, value: originalValue)
			
			dispatch_after(delay, dispatch_get_main_queue()) {
				self.changeZoom(zoom: zoom2, value: originalValue)
				
				dispatch_after(delay, dispatch_get_main_queue()) {
					self.changeZoom(zoom: zoom3, value: originalValue)
					
					dispatch_after(delay, dispatch_get_main_queue()) {
						self.changeZoom(zoom: zoom4, value: originalValue)
						self.enablePropagation()

						let changeModel = SliderDidChangeModel(
							value: originalValue,
							valueUpdated: false,
							zoom: self.model.zoom,
							zoomUpdated: true
						)
						self.valueDidChange?(changeModel: changeModel)
					}
				}
			}
		}
	}

	func changeZoom(zoom zoom: Float, value: Double) {
		let clampedZoom = model.clampZoom(zoom)
		if model.zoom == clampedZoom {
			return // no need to update UI
		}
		model.zoom = clampedZoom
		//print(String(format: "update zoom: %.5f   \(model.zoomMode)", zoom))
		reloadSlider()
		
		self.value = value
	}
	
	func reloadSlider() {
		model.updateRange()
		updateContentInset()
		collectionView.reloadData()
		layout.itemSize = computeItemSize()
		layout.invalidateLayout()
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
		instance.registerClass(PrecisionSlider_InnerCollectionViewSingleCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewSingleCell.identifier)
		instance.registerClass(PrecisionSlider_InnerCollectionViewFirstCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewFirstCell.identifier)
		instance.registerClass(PrecisionSlider_InnerCollectionViewLastCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewLastCell.identifier)
		instance.registerClass(PrecisionSlider_InnerCollectionViewFullCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewFullCell.identifier)
		instance.contentInset = UIEdgeInsetsZero
		instance.delegate = self
		instance.dataSource = self
		return instance
	}()
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if enablePropagationCounter < 0 {
			return
		}
		guard let valueDidChange = self.valueDidChange else {
			return
		}
		let changeModel = SliderDidChangeModel(
			value: self.value,
			valueUpdated: true,
			zoom: self.model.zoom,
			zoomUpdated: false
		)
		valueDidChange(changeModel: changeModel)
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
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if model.hasOnePartialItem {
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PrecisionSlider_InnerCollectionViewSingleCell.identifier, forIndexPath: indexPath) as! PrecisionSlider_InnerCollectionViewSingleCell
			return cell
		}
		
		let labelText: String?  = model.labelTextForIndexPath(indexPath)
		let markColor: UIColor? = model.markColorForIndexPath(indexPath)
		
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
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PrecisionSlider_InnerCollectionViewFullCell.identifier, forIndexPath: indexPath) as! PrecisionSlider_InnerCollectionViewFullCell
		cell.label.text = labelText
		cell.mark.backgroundColor = markColor
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
