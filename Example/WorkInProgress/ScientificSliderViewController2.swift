// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class FlowLayout: UICollectionViewFlowLayout {
	
}

class SliderCell: UICollectionViewCell {
	static let identifier = "cell"
}


class ScientificSliderViewController2: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	
	var scale: CGFloat = 1.0
	var originalScale: CGFloat = 1.0
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.lightGrayColor()
		view.addSubview(collectionView)
	}
	
	lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
		let instance = UIPinchGestureRecognizer(target: self, action: #selector(ScientificSliderViewController2.handlePinch))
		return instance
	}()
	
	func handlePinch(gesture: UIPinchGestureRecognizer) {
//		print("!!!!!!!")
		
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
			
//			layout.itemSize = computeItemSize()
			layout.invalidateLayout()
//			collectionView.collectionViewLayout.invalidateLayout()
		}
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		var frame = view.bounds
		frame.size.height = 100
		frame.origin.y = (view.bounds.height - frame.height) * 0.5
		collectionView.frame = frame
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		view.addGestureRecognizer(pinchGestureRecognizer)
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		view.removeGestureRecognizer(pinchGestureRecognizer)
	}
	
	lazy var layout: FlowLayout = {
		return self.createFlowLayout()
	}()
	
	func computeItemSize() -> CGSize {
		let w = 30 * scale
		return CGSize(width: w, height: w)
	}
	
	func createFlowLayout() -> FlowLayout {
		let instance = FlowLayout()
		instance.scrollDirection = .Horizontal
		instance.minimumInteritemSpacing = 1
		instance.minimumLineSpacing = 1
//		instance.itemSize = computeItemSize()
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
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return computeItemSize()
	}
	
//	func collectionView_setup() {
//		collectionView.delegate = self
//		collectionView.dataSource = self
//	}
	
//	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//		return collectionView
//	}
	

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SliderCell.identifier, forIndexPath: indexPath) as! SliderCell
		cell.backgroundColor = UIColor.blackColor()
		
		return cell
	}
	
}
