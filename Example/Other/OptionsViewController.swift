// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class OptionsViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Options"
		builder.toolbarMode = .none
		builder += SectionHeaderTitleFormItem().title("Options")
		builder += adoptBitcoin
		builder += exploreSpace
		builder += worldPeace
		builder += stopGlobalWarming
		builder += SectionFormItem()
		builder += randomizeButton
	}

	lazy var adoptBitcoin: OptionPickerFormItem = {
		let instance = OptionPickerFormItem()
		instance.title("Adopt Bitcoin?").placeholder("required")
		instance.append("Strongly disagree").append("Disagree").append("Neutral").append("Agree").append("Strongly agree")
		instance.selectOptionWithTitle("Neutral")
		instance.valueDidChange = { (selected: OptionRowModel?) in
			print("adopt bitcoin: \(String(describing: selected))")
		}
		return instance
		}()

	lazy var exploreSpace: OptionPickerFormItem = {
		let instance = OptionPickerFormItem()
		instance.title("Explore Space?").placeholder("required")
		instance.append("Strongly disagree").append("Disagree").append("Neutral").append("Agree").append("Strongly agree")
		instance.selectOptionWithTitle("Neutral")
		instance.valueDidChange = { (selected: OptionRowModel?) in
			print("explore space: \(String(describing: selected))")
		}
		return instance
		}()

	lazy var worldPeace: OptionPickerFormItem = {
		let instance = OptionPickerFormItem()
		instance.title("World Peace?").placeholder("required")
		instance.append("Strongly disagree").append("Disagree").append("Neutral").append("Agree").append("Strongly agree")
		instance.selectOptionWithTitle("Neutral")
		instance.valueDidChange = { (selected: OptionRowModel?) in
			print("world peace: \(String(describing: selected))")
		}
		return instance
		}()

	lazy var stopGlobalWarming: OptionPickerFormItem = {
		let instance = OptionPickerFormItem()
		instance.title("Stop Global Warming?").placeholder("required")
		instance.append("Strongly disagree", identifier: "strongly_disagree")
		instance.append("Disagree", identifier: "disagree")
		instance.append("Neutral", identifier: "neutral")
		instance.append("Agree", identifier: "agree")
		instance.append("Strongly agree", identifier: "strongly_agree")
		instance.selectOptionWithIdentifier("neutral")
		instance.valueDidChange = { (selected: OptionRowModel?) in
			print("stop global warming: \(String(describing: selected))")
		}
		return instance
		}()

	lazy var randomizeButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Randomize"
		instance.action = { [weak self] in
			self?.randomize()
		}
		return instance
		}()

	func assignRandomOption(_ optionField: OptionPickerFormItem) {
		var selected: OptionRowModel? = nil
		let options = optionField.options
		if options.count > 0 {
			let i = randomInt(0, options.count)
			if i < options.count {
				selected = options[i]
			}
		}
		optionField.selected = selected
	}

	func randomize() {
		assignRandomOption(adoptBitcoin)
		assignRandomOption(exploreSpace)
		assignRandomOption(worldPeace)
		assignRandomOption(stopGlobalWarming)
	}
}
