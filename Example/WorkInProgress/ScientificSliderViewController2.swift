// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class FlowLayout: UICollectionViewFlowLayout {
	
}

class SliderCell: UICollectionViewCell {
	static let identifier = "cell"
}


class ScientificSliderViewController2: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.lightGrayColor()
		view.addSubview(collectionView)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		var frame = view.bounds
		frame.size.height = 100
		frame.origin.y = (view.bounds.height - frame.height) * 0.5
		collectionView.frame = frame
	}
	
	lazy var collectionViewLayout: FlowLayout = {
		let instance = FlowLayout()
		instance.scrollDirection = .Horizontal
		instance.minimumInteritemSpacing = 0
		instance.minimumLineSpacing = 0
		return instance
	}()
	
	lazy var collectionView: UICollectionView = {
		let instance = UICollectionView(frame: CGRectZero, collectionViewLayout: self.collectionViewLayout)
//		instance.showsHorizontalScrollIndicator = false
		instance.backgroundColor = UIColor.whiteColor()
		instance.delegate = self
		instance.dataSource = self
//		instance.bounces = false
		instance.allowsSelection = false
		instance.registerClass(SliderCell.self, forCellWithReuseIdentifier: SliderCell.identifier)
		return instance
	}()
	

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SliderCell.identifier, forIndexPath: indexPath) as! SliderCell
		
		return cell
	}
}
