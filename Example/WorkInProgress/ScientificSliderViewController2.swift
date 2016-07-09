// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class CollectionViewModel {
	var count = 1000
	var scale: CGFloat = 60.0
	
	var scaleRounded: CGFloat {
		return floor(scale + 0.5)
	}
	
	static let height: CGFloat = 130
}

class MyCollectionView: UICollectionView {
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		addSubview(leftCoverView)
		addSubview(rightCoverView)
	}
	
	lazy var leftCoverView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor(red: 0.0, green: 0, blue: 0, alpha: 0.125)
		instance.userInteractionEnabled = false
		return instance
	}()
	
	lazy var rightCoverView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor(red: 0.0, green: 0, blue: 0, alpha: 0.125)
		instance.userInteractionEnabled = false
		return instance
	}()
	
	override func layoutSubviews() {
		super.layoutSubviews()

		let (leftFrame, rightFrame) = bounds.divide(round(bounds.width/2), fromEdge: .MinXEdge)
		leftCoverView.frame = CGRect(x: leftFrame.origin.x, y: leftFrame.origin.y, width: leftFrame.size.width - 1, height: leftFrame.size.height)
		rightCoverView.frame = rightFrame
	}
}

class FlowLayout: UICollectionViewFlowLayout {
	weak var model: CollectionViewModel?
	
	override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
		return nil
	}
	
	override func prepareLayout() {
		super.prepareLayout()
		
		scrollDirection = .Horizontal
		minimumInteritemSpacing = 0
		minimumLineSpacing = 0
		sectionInset = UIEdgeInsetsZero
		headerReferenceSize = CGSizeZero
		footerReferenceSize = CGSizeZero
	}
	
	override func collectionViewContentSize() -> CGSize {
		guard let model = self.model else {
			return CGSizeZero
		}
		return CGSize(width: model.scaleRounded * CGFloat(model.count), height: CollectionViewModel.height)
	}
	

//	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//		return true
//	}
	
//	override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//		var result = [UICollectionViewLayoutAttributes]()
//		for item in self.itemA
//	}
}

class SliderCell: UICollectionViewCell {
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
		addSubview(leftBorder)
		addSubview(label)
	}
	
	lazy var leftBorder: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.blackColor()
		return instance
	}()
	
	lazy var label: UILabel = {
		let instance = UILabel()
		instance.text = "42"
		return instance
	}()
	
	override func layoutSubviews() {
		super.layoutSubviews()
		leftBorder.frame = CGRect(x: 0, y: 0, width: 1, height: bounds.height)
		
		let labelHidden = self.bounds.width < 30
		label.hidden = labelHidden

		label.sizeToFit()
		let labelFrame = label.frame
		label.frame = CGRect(x: 7, y: 5, width: bounds.width - 10, height: labelFrame.height)
	}
}

class ScientificSliderViewController2: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
	
	var originalScale: CGFloat = 1.0
	var originalValue: CGFloat?

	
	override func loadView() {
		super.loadView()
		self.automaticallyAdjustsScrollViewInsets = false
		
		view.backgroundColor = UIColor.lightGrayColor()
		view.addSubview(collectionView)
		view.addSubview(titleLabel)
		view.addSubview(valueLabel)
		view.addSubview(usageLabel)
	}
	
	lazy var model: CollectionViewModel = {
		let instance = CollectionViewModel()
		return instance
	}()
	
	lazy var usageLabel: UILabel = {
		let instance = UILabel()
		instance.text = "Pinch to adjust magnitude.\n\nPan left/right to adjust value."
		instance.numberOfLines = 0
		instance.textAlignment = .Center
		instance.font = UIFont.systemFontOfSize(17)
		return instance
	}()
	
	lazy var titleLabel: UILabel = {
		let instance = UILabel()
		instance.text = "Value"
		instance.numberOfLines = 0
		instance.textAlignment = .Left
		instance.font = UIFont.boldSystemFontOfSize(18)
		return instance
	}()
	
	lazy var valueLabel: UILabel = {
		let instance = UILabel()
		instance.text = "-"
		instance.numberOfLines = 0
		instance.textAlignment = .Right
		instance.font = UIFont.systemFontOfSize(20)
		return instance
	}()

	func updateLabel() {
		if let value = self.value {
			valueLabel.text = String(format: "%.3f", value)
		} else {
			valueLabel.text = "---"
		}
	}
	
	var value: CGFloat? {
		let scale = model.scaleRounded
		if scale < 0.1 {
			return nil
		}
		
		let halfWidth = collectionView.bounds.width / 2
		let midX = collectionView.contentOffset.x + halfWidth
		let x: CGFloat = midX / scale
		return x
	}
	
	func scrollToValue(value: CGFloat) {
		let scale = model.scaleRounded
		if scale < 0.1 {
			return
		}
		
		let halfWidth = collectionView.bounds.width / 2
		let offsetX: CGFloat = round((scale * value) - halfWidth)
		collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
	}
	
	lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
		let instance = UIPinchGestureRecognizer(target: self, action: #selector(ScientificSliderViewController2.handlePinch))
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
			var scale = originalScale * gesture.scale
			if scale < 0.0 {
				scale = 0.01
			}
			model.scale = scale
			
			
//			[self.collectionView removeGestureRecognizer:self.gesture];
//			UICollectionViewFlowLayout *newLayout = [[UICollectionViewFlowLayout alloc] init];
//			[self.collectionView setCollectionViewLayout:newLayout animated:YES completion:^(BOOL finished) {
//			[self.collectionView addGestureRecognizer:self.gesture];
//			}];
			
//			collectionView.removeGestureRecognizer(gesture)
//			let layout = createFlowLayout()
//			collectionView.setCollectionViewLayout(layout, animated: true, completion: { [weak self] (finished) in
//				self?.collectionView.addGestureRecognizer(gesture)
//			})
			
			layout.itemSize = computeItemSize()
			layout.invalidateLayout()
//			collectionView.collectionViewLayout.invalidateLayout()
			
			if let value = originalValue {
				scrollToValue(value)
			}
			
			updateLabel()
		}
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		
		do {
			let frame = view.bounds.insetBy(dx: 10, dy: 80)
			let (f0, _) = frame.divide(200, fromEdge: .MinYEdge)
			usageLabel.frame = f0
		}

		
		var frame = view.bounds
		frame.size.height = CollectionViewModel.height
		frame.origin.y = (view.bounds.height - frame.height) * 0.5
		collectionView.frame = frame
//		collectionView.setNeedsLayout()
//		collectionView.reloadData()
//		layout.invalidateLayout()
		
		titleLabel.sizeToFit()
		valueLabel.sizeToFit()
		
		let s0 = titleLabel.bounds.size
		let f0 = CGRect(x: 10, y: frame.minY - s0.height - 10, width: view.bounds.width - 20, height: s0.height)
		titleLabel.frame = f0

		let s1 = valueLabel.bounds.size
		let f1 = CGRect(x: 10, y: frame.minY - s1.height - 10, width: view.bounds.width - 20, height: s1.height)
		valueLabel.frame = f1
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		view.addGestureRecognizer(pinchGestureRecognizer)
		
		layout.itemSize = computeItemSize()
		layout.invalidateLayout()
		collectionView.reloadData()
		collectionView.contentOffset = CGPointZero
		collectionView.contentInset = UIEdgeInsetsZero
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		view.removeGestureRecognizer(pinchGestureRecognizer)
	}
	
	lazy var layout: FlowLayout = {
		return self.createFlowLayout()
	}()
	
	func computeItemSize() -> CGSize {
//		return CGSize(width: w, height: collectionView.bounds.height)
		return CGSize(width: model.scaleRounded, height: CollectionViewModel.height)
//		return CGSize(width: w, height: 40)
//		return CGSize(width: w, height: 150)
	}
	
	func createFlowLayout() -> FlowLayout {
		let instance = FlowLayout()
//		instance.scrollDirection = .Horizontal
//		instance.minimumInteritemSpacing = 1
//		instance.minimumLineSpacing = 1
//		instance.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//		instance.headerReferenceSize = CGSizeZero
//		instance.footerReferenceSize = CGSizeZero
		instance.itemSize = computeItemSize()
		instance.model = self.model
		return instance
	}
	
	lazy var collectionView: MyCollectionView = {
		let instance = MyCollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
		instance.showsHorizontalScrollIndicator = false
		instance.showsVerticalScrollIndicator = false
		instance.backgroundColor = UIColor.whiteColor()
		instance.delegate = self
		instance.dataSource = self
		instance.bounces = false
		instance.alwaysBounceHorizontal = true
		instance.alwaysBounceVertical = false
//		instance.pagingEnabled = false
//		instance.directionalLockEnabled = true
//		instance.allowsSelection = false
		instance.registerClass(SliderCell.self, forCellWithReuseIdentifier: SliderCell.identifier)
		return instance
	}()
	
	var counter = 0
	func scrollViewDidScroll(scrollView: UIScrollView) {
		counter += 1
//		print("!!!!!! \(counter)")
		// TODO: only invoke every 0.2 second. This function gets hammered when scrolling
		updateLabel()
	}
	
//	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//		return computeItemSize()
//	}
	
//	func collectionView_setup() {
//		collectionView.delegate = self
//		collectionView.dataSource = self
//	}
	
//	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//		return collectionView
//	}
	

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return model.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SliderCell.identifier, forIndexPath: indexPath) as! SliderCell
		cell.label.text = String(indexPath.row % 10)
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsZero
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSizeZero
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSizeZero
	}
}
