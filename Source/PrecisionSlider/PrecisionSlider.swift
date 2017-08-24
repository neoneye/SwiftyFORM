// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
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

	typealias SliderDidChangeBlock = (_ changeModel: SliderDidChangeModel) -> Void
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
		addSubview(collectionViewWrapper)
		collectionViewWrapper.addSubview(collectionView)

		addSubview(leftCoverView)
		addSubview(rightCoverView)
		addSubview(zoomInButton)
		addSubview(zoomOutButton)
		addSubview(zoomLabel)

		collectionViewWrapper.addGestureRecognizer(pinchGestureRecognizer)
		collectionViewWrapper.addGestureRecognizer(oneTouchDoubleTapGestureRecognizer)
		collectionViewWrapper.addGestureRecognizer(twoTouchDoubleTapGestureRecognizer)
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
		collectionViewWrapper.frame = bounds
		collectionView.frame = bounds

		updateContentInset()

		do {
			let (left, right) = bounds.divided(atDistance: round(bounds.width/2), from: .minXEdge)
			leftCoverView.frame = left.divided(atDistance: 1, from: .maxXEdge).remainder
			rightCoverView.frame = right
		}

		if !zoomUIHidden {
			let halfHeight = floor(bounds.height / 2)
			let right = bounds.divided(atDistance: halfHeight, from: .maxXEdge).slice
			let (a, b) = right.divided(atDistance: halfHeight, from: .maxYEdge)
			zoomOutButton.frame = a
			zoomInButton.frame = b
			zoomLabel.frame = right
		}
	}

	lazy var leftCoverView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
		instance.isUserInteractionEnabled = false
		return instance
	}()

	lazy var rightCoverView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
		instance.isUserInteractionEnabled = false
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
	func setContentOffset(_ value: Double) {
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

	// MARK: Pinch gesture for zoom in/out

	lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
		let instance = UIPinchGestureRecognizer(target: self, action: #selector(PrecisionSlider.handlePinch))
		instance.delegate = self
		return instance
	}()

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return false
	}

	@objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
		if gesture.state == .began {
			originalZoom = model.zoom
			originalValue = self.value
		}
		if gesture.state == .changed {
			let zoomBefore = model.zoom
			let zoom = Float(log10(pow(10, Double(originalZoom)) * Double(gesture.scale)))
			changeZoom(zoom: zoom, value: originalValue)
			let zoomAfter = model.zoom

			if zoomBefore != zoomAfter {
				reloadZoomLabel()
				let changeModel = SliderDidChangeModel(
					value: originalValue,
					valueUpdated: false,
					zoom: model.zoom,
					zoomUpdated: true
				)
				valueDidChange?(changeModel)
			}
		}
	}

	// MARK: Gesture 'one-finger double-tap' for zoom in

	lazy var oneTouchDoubleTapGestureRecognizer: UITapGestureRecognizer = {
		let instance = UITapGestureRecognizer(target: self, action: #selector(PrecisionSlider.handleOneTouchDoubleTap))
		instance.numberOfTapsRequired = 2
		instance.numberOfTouchesRequired = 1
		return instance
	}()

	@objc func handleOneTouchDoubleTap(_ gesture: UIPinchGestureRecognizer) {
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

		let delay = DispatchTime.now() + Double(Int64(0.08 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: delay) {
			self.changeZoom(zoom: zoom1, value: originalValue)

			DispatchQueue.main.asyncAfter(deadline: delay) {
				self.changeZoom(zoom: zoom2, value: originalValue)

				DispatchQueue.main.asyncAfter(deadline: delay) {
					self.changeZoom(zoom: zoom3, value: originalValue)

					DispatchQueue.main.asyncAfter(deadline: delay) {
						self.changeZoom(zoom: zoom4, value: originalValue)
						self.enablePropagation()

						self.reloadZoomLabel()
						let changeModel = SliderDidChangeModel(
							value: originalValue,
							valueUpdated: false,
							zoom: self.model.zoom,
							zoomUpdated: true
						)
						self.valueDidChange?(changeModel)
					}
				}
			}
		}
	}

	// MARK: Gesture 'two-finger double-tap' for zoom out

	lazy var twoTouchDoubleTapGestureRecognizer: UITapGestureRecognizer = {
		let instance = UITapGestureRecognizer(target: self, action: #selector(PrecisionSlider.handleTwoTouchDoubleTap))
		instance.numberOfTapsRequired = 2
		instance.numberOfTouchesRequired = 2
		return instance
	}()

	@objc func handleTwoTouchDoubleTap(_ gesture: UIPinchGestureRecognizer) {
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

		let delay = DispatchTime.now() + Double(Int64(0.08 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: delay) {
			self.changeZoom(zoom: zoom1, value: originalValue)

			DispatchQueue.main.asyncAfter(deadline: delay) {
				self.changeZoom(zoom: zoom2, value: originalValue)

				DispatchQueue.main.asyncAfter(deadline: delay) {
					self.changeZoom(zoom: zoom3, value: originalValue)

					DispatchQueue.main.asyncAfter(deadline: delay) {
						self.changeZoom(zoom: zoom4, value: originalValue)
						self.enablePropagation()

						self.reloadZoomLabel()
						let changeModel = SliderDidChangeModel(
							value: originalValue,
							valueUpdated: false,
							zoom: self.model.zoom,
							zoomUpdated: true
						)
						self.valueDidChange?(changeModel)
					}
				}
			}
		}
	}

	// MARK: Zoom UI

	var zoomUIHidden: Bool {
		get {
			return zoomLabel.isHidden && zoomInButton.isHidden && zoomOutButton.isHidden
		}
		set {
			zoomLabel.isHidden = newValue
			zoomInButton.isHidden = newValue
			zoomOutButton.isHidden = newValue
			setNeedsLayout()
		}
	}

	// MARK: Zoom UI - Label that shows the current zoom factor

	lazy var zoomLabel: UILabel = {
		let instance = UILabel()
		instance.textColor = UIColor(white: 0.2, alpha: 1.0)
		instance.text = "0.0"
		instance.font = UIFont.systemFont(ofSize: 12)
		instance.textAlignment = .center
		return instance
	}()

	func reloadZoomLabel() {
		zoomLabel.text = String(format: "%.1f", model.zoom)
	}

	// MARK: Zoom UI - Button for zoom in

	lazy var zoomInButton: UIButton = {
		let instance = UIButton(type: .custom)
		instance.backgroundColor = UIColor(white: 0.8, alpha: 0.85)
		instance.setTitleColor(UIColor(white: 0.2, alpha: 1.0), for: UIControlState())
		instance.titleLabel?.font = UIFont.systemFont(ofSize: 32)
		instance.showsTouchWhenHighlighted = true
		instance.setTitle("+", for: UIControlState())
		instance.addTarget(self, action: #selector(PrecisionSlider.zoomInButtonAction), for: .touchUpInside)
		return instance
	}()

	@objc func zoomInButtonAction() {
		let originalZoom = model.zoom
		let originalValue = self.value

		let clampedZoom = model.clampZoom(originalZoom + 1.0)
		if model.zoom == clampedZoom {
			return // already zoomed in, no need to update UI
		}

		disablePropagation()
		changeZoom(zoom: clampedZoom, value: originalValue)
		enablePropagation()

		reloadZoomLabel()
		let changeModel = SliderDidChangeModel(
			value: originalValue,
			valueUpdated: false,
			zoom: model.zoom,
			zoomUpdated: true
		)
		valueDidChange?(changeModel)
	}

	// MARK: Zoom UI - Button for zoom out

	lazy var zoomOutButton: UIButton = {
		let instance = UIButton(type: .custom)
		instance.backgroundColor = UIColor(white: 0.8, alpha: 0.85)
		instance.setTitleColor(UIColor(white: 0.2, alpha: 1.0), for: UIControlState())
		instance.titleLabel?.font = UIFont.systemFont(ofSize: 32)
		instance.showsTouchWhenHighlighted = true
		instance.setTitle("-", for: UIControlState())
		instance.addTarget(self, action: #selector(PrecisionSlider.zoomOutButtonAction), for: .touchUpInside)
		return instance
	}()

	@objc func zoomOutButtonAction() {
		let originalZoom = model.zoom
		let originalValue = self.value

		let clampedZoom = model.clampZoom(originalZoom - 1.0)
		if model.zoom == clampedZoom {
			return // already zoomed out, no need to update UI
		}

		disablePropagation()
		changeZoom(zoom: clampedZoom, value: originalValue)
		enablePropagation()

		reloadZoomLabel()
		let changeModel = SliderDidChangeModel(
			value: originalValue,
			valueUpdated: false,
			zoom: model.zoom,
			zoomUpdated: true
		)
		valueDidChange?(changeModel)
	}

	func changeZoom(zoom: Float, value: Double) {
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
		instance.scrollDirection = .horizontal
		instance.minimumInteritemSpacing = 0
		instance.minimumLineSpacing = 0
		instance.sectionInset = UIEdgeInsets.zero
		instance.headerReferenceSize = CGSize.zero
		instance.footerReferenceSize = CGSize.zero
		instance.itemSize = self.computeItemSize()
		instance.model = self.model
		return instance
	}()

	/**
	The collectionview is wrapped in a plain UIView, that doesn't do anything.
	This lets us install custom gesture recognizers for pinch and double-tap.
	*/
	lazy var collectionViewWrapper: UIView = {
		return UIView()
	}()

	lazy var collectionView: UICollectionView = {
		let instance = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
		instance.showsHorizontalScrollIndicator = false
		instance.showsVerticalScrollIndicator = false
		instance.backgroundColor = UIColor.white
		instance.bounces = false
		instance.alwaysBounceHorizontal = true
		instance.alwaysBounceVertical = false
		instance.register(PrecisionSlider_InnerCollectionViewSingleCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewSingleCell.identifier)
		instance.register(PrecisionSlider_InnerCollectionViewFirstCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewFirstCell.identifier)
		instance.register(PrecisionSlider_InnerCollectionViewLastCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewLastCell.identifier)
		instance.register(PrecisionSlider_InnerCollectionViewFullCell.self, forCellWithReuseIdentifier: PrecisionSlider_InnerCollectionViewFullCell.identifier)
		instance.contentInset = UIEdgeInsets.zero
		instance.delegate = self
		instance.dataSource = self
		return instance
	}()

	// MARK: UICollectionView delegate/datasource

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
		valueDidChange(changeModel)
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if model.hasOnePartialItem {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrecisionSlider_InnerCollectionViewSingleCell.identifier, for: indexPath) as! PrecisionSlider_InnerCollectionViewSingleCell
			return cell
		}

		let labelText: String?  = model.labelTextForIndexPath(indexPath)
		let markColor: UIColor? = model.markColorForIndexPath(indexPath)

		let count = self.collectionView(collectionView, numberOfItemsInSection: 0)
		let isFirst = indexPath.row == 0
		let isLast = indexPath.row == count - 1

		if isFirst && model.hasPartialItemBefore {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrecisionSlider_InnerCollectionViewFirstCell.identifier, for: indexPath) as! PrecisionSlider_InnerCollectionViewFirstCell
			cell.label.text = labelText
			cell.mark.backgroundColor = markColor
			cell.configure(partialLength: model.lengthOfPartialItemBefore, fullLength: model.lengthOfFullItem)
			return cell
		}
		if isLast && model.hasPartialItemAfter {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrecisionSlider_InnerCollectionViewLastCell.identifier, for: indexPath) as! PrecisionSlider_InnerCollectionViewLastCell
			cell.label.text = labelText
			cell.mark.backgroundColor = markColor
			cell.configure(partialLength: model.lengthOfPartialItemAfter, fullLength: model.lengthOfFullItem)
			return cell
		}
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrecisionSlider_InnerCollectionViewFullCell.identifier, for: indexPath) as! PrecisionSlider_InnerCollectionViewFullCell
		cell.label.text = labelText
		cell.mark.backgroundColor = markColor
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

	override var collectionViewContentSize: CGSize {
		guard let model = self.model else {
			print("no model")
			return CGSize.zero
		}
		return CGSize(width: CGFloat(model.lengthOfContent), height: PrecisionSlider_InnerModel.height)
	}
}
