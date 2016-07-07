// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class MyCollectionView: UICollectionView {
}

class FlowLayout: UICollectionViewFlowLayout {
	override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
		return nil
	}
	
	override func prepareLayout() {
		super.prepareLayout()
		
		scrollDirection = .Horizontal
		minimumInteritemSpacing = 1
		minimumLineSpacing = 1
		sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		headerReferenceSize = CGSizeZero
		footerReferenceSize = CGSizeZero
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
		addSubview(tl)
		addSubview(tr)
		addSubview(bl)
		addSubview(br)
	}
	
	lazy var tl: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.redColor()
		return instance
	}()
	
	lazy var tr: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.blueColor()
		return instance
	}()
	
	lazy var bl: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.greenColor()
		return instance
	}()
	
	lazy var br: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.whiteColor()
		return instance
	}()
	
	override func layoutSubviews() {
		super.layoutSubviews()
		tl.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
		tr.frame = CGRect(x: bounds.maxX - 10, y: 0, width: 10, height: 10)
		bl.frame = CGRect(x: 0, y: bounds.maxY - 10, width: 10, height: 10)
		br.frame = CGRect(x: bounds.maxX - 10, y: bounds.maxY - 10, width: 10, height: 10)
	}
}

class ScientificSliderViewController2: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
	
	var scale: CGFloat = 1.0
	var originalScale: CGFloat = 1.0
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.lightGrayColor()
		view.addSubview(collectionView)
		view.addSubview(titleLabel)
		view.addSubview(valueLabel)
		view.addSubview(usageLabel)
	}
	
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
		let size = computeItemSize()
		let w = size.width
		if w < 0.1 {
			valueLabel.text = "---"
			return
		}
		let x: CGFloat = collectionView.contentOffset.x / w
		let s = String(format: "%.3f", x)
		valueLabel.text = s
	}
	
	lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
		let instance = UIPinchGestureRecognizer(target: self, action: #selector(ScientificSliderViewController2.handlePinch))
		return instance
	}()
	
	func handlePinch(gesture: UIPinchGestureRecognizer) {
		if gesture.state == .Began {
			originalScale = scale
		}
		if gesture.state == .Changed {
			scale = originalScale * gesture.scale
			if scale < 0.0 {
				scale = 0.01
			}
			
			
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
			
			updateLabel()
		}
	}
	
	let collectionViewHeight: CGFloat = 100
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		
		do {
			let frame = view.bounds.insetBy(dx: 10, dy: 80)
			let (f0, _) = frame.divide(200, fromEdge: .MinYEdge)
			usageLabel.frame = f0
		}

		
		var frame = view.bounds
		frame.size.height = collectionViewHeight
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
		let w = round(25 * scale)
//		return CGSize(width: w, height: collectionView.bounds.height)
		return CGSize(width: w, height: collectionViewHeight)
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
		return instance
	}
	
	lazy var collectionView: UICollectionView = {
		let instance = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
//		instance.showsHorizontalScrollIndicator = false
		instance.backgroundColor = UIColor.whiteColor()
		instance.delegate = self
		instance.dataSource = self
//		instance.bounces = false
//		instance.allowsSelection = false
		instance.registerClass(SliderCell.self, forCellWithReuseIdentifier: SliderCell.identifier)
		
//		instance.minimumZoomScale = 1.0
//		instance.maximumZoomScale = 2.0
//		instance.zoomScale = 1.5
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
		return 1000
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SliderCell.identifier, forIndexPath: indexPath) as! SliderCell
		cell.backgroundColor = UIColor.blackColor()
		
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
