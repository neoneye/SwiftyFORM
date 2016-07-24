// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class CollectionViewModel {
	var count = 1000
	var scale: CGFloat = 60.0
	
	var scaleRounded: CGFloat {
		let result = floor(scale + 0.5)
		if result < 0.1 {
			return 0.1
		}
		return result
	}
	
	static let height: CGFloat = 130
}

class FlowLayout: UICollectionViewFlowLayout {
	weak var model: CollectionViewModel?
	
	override func collectionViewContentSize() -> CGSize {
		guard let model = self.model else {
			print("no model")
			return CGSizeZero
		}
		return CGSize(width: model.scaleRounded * CGFloat(model.count), height: CollectionViewModel.height)
	}
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
		backgroundColor = UIColor.whiteColor()
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
		instance.text = "0"
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

class MyView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
	var originalScale: CGFloat = 1.0
	var originalValue: CGFloat?
	
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
	}
	
	func viewWillAppear() {
		addGestureRecognizer(pinchGestureRecognizer)
		
		layout.itemSize = computeItemSize()
		layout.invalidateLayout()
		collectionView.reloadData()
	}
	
	func viewDidDisappear() {
		removeGestureRecognizer(pinchGestureRecognizer)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		collectionView.frame = bounds
		
		let halfWidth = round(bounds.width/2)-1
		collectionView.contentInset = UIEdgeInsets(top: 0, left: halfWidth, bottom: 0, right: halfWidth)

		let (leftFrame, rightFrame) = bounds.divide(round(bounds.width/2), fromEdge: .MinXEdge)
		leftCoverView.frame = CGRect(x: leftFrame.origin.x, y: leftFrame.origin.y, width: leftFrame.size.width - 1, height: leftFrame.size.height)
		rightCoverView.frame = rightFrame
	}

	lazy var leftCoverView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
		instance.userInteractionEnabled = false
		return instance
	}()
	
	lazy var rightCoverView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
		instance.userInteractionEnabled = false
		return instance
	}()

	lazy var model: CollectionViewModel = {
		let instance = CollectionViewModel()
		return instance
	}()
	
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
		let instance = UIPinchGestureRecognizer(target: self, action: #selector(MyView.handlePinch))
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
			
			layout.itemSize = computeItemSize()
			layout.invalidateLayout()
			
			if let value = originalValue {
				scrollToValue(value)
			}
			
			valueDidChange?()
		}
	}
	
	func computeItemSize() -> CGSize {
		return CGSize(width: model.scaleRounded, height: CollectionViewModel.height)
	}
	
	lazy var layout: FlowLayout = {
		let instance = FlowLayout()
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
		instance.backgroundColor = UIColor.blackColor()
		instance.bounces = false
		instance.alwaysBounceHorizontal = true
		instance.alwaysBounceVertical = false
		instance.registerClass(SliderCell.self, forCellWithReuseIdentifier: SliderCell.identifier)
		instance.contentInset = UIEdgeInsetsZero
		instance.delegate = self
		instance.dataSource = self
		return instance
	}()
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		valueDidChange?()
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return model.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SliderCell.identifier, forIndexPath: indexPath) as! SliderCell
		cell.label.text = String(indexPath.row % 10)
		return cell
	}
}

class ScientificSliderViewController2: UIViewController {
	
	override func loadView() {
		super.loadView()
		self.automaticallyAdjustsScrollViewInsets = false
		
		view.backgroundColor = UIColor.lightGrayColor()
		view.addSubview(myView)
		view.addSubview(titleLabel)
		view.addSubview(valueLabel)
		view.addSubview(usageLabel)
	}
	
	lazy var myView: MyView = {
		let instance = MyView()
		instance.valueDidChange = { [weak self] in
			self?.updateLabel()
		}
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
		if let value = myView.value {
			valueLabel.text = String(format: "%.3f", value)
		} else {
			valueLabel.text = "---"
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
		myView.frame = frame

		
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
		myView.viewWillAppear()
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		myView.viewDidDisappear()
	}
}
