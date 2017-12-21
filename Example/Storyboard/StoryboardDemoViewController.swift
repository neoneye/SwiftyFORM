// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class StoryboardDemoViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Storyboard Demo"
		builder += voteCountSlider
		builder += SectionHeaderTitleFormItem()
		builder += voteButton
	}
	
	lazy var voteCountSlider: PrecisionSliderFormItem = {
		let instance = PrecisionSliderFormItem().decimalPlaces(0).minimumValue(0).maximumValue(1000).value(500).behavior(.expandedAlways)
		instance.title = "Vote Count"
		return instance
	}()
	
	lazy var voteButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Submit Vote"
		instance.action = { [weak self] in
			self?.voteButtonAction()
		}
		return instance
	}()
	
	func voteButtonAction() {
		let value: Int = Int(voteCountSlider.actualValue)
		let config = VoteViewControllerConfig(voteCount: value)
		let vc = VoteViewController.create(config: config)
		navigationController?.pushViewController(vc, animated: true)
	}
}
