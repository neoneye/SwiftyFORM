// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

class MyCollectionViewController: UICollectionViewController {
	init() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.itemSize = CGSize(width: 80, height: 80)
		super.init(collectionViewLayout: layout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
		cell.backgroundColor = UIColor.redColor()
		return cell
	}
}
