// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

struct VoteViewControllerConfig {
	let voteCount: Int
}

class VoteViewController: UIViewController {
	@IBOutlet weak var voteCount: UILabel!
	private var config: VoteViewControllerConfig?
	
	static func create(config: VoteViewControllerConfig?) -> VoteViewController {
		let storyboard = UIStoryboard(name: "VoteViewController", bundle: Bundle.main)
		let vc = storyboard.instantiateInitialViewController() as! VoteViewController
		vc.config = config
		return vc
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let config = self.config {
			voteCount.text = String(config.voteCount)
		} else {
			voteCount.text = "N/A"
		}
	}
}
