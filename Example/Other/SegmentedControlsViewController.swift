// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class SegmentedControlsViewController: FormViewController {

	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Segmented Controls"
		builder += SectionHeaderTitleFormItem(title: "Please select")
		builder += animal
		builder += spicy
		builder += drink
		builder += popcorn
		builder += SectionHeaderTitleFormItem(title: "World-wide delivery")
		builder += submitButton
		builder += SectionFooterTitleFormItem(title: "The animal may die during transport!")
		builder += SectionFormItem()
		builder += randomizeButton
	}

	lazy var animal: SegmentedControlFormItem = {
		let instance = SegmentedControlFormItem()
		instance.title = "Animal"
		instance.items = ["Cat", "Dog", "Fish"]
		return instance
	}()

	lazy var spicy: SegmentedControlFormItem = {
		let instance = SegmentedControlFormItem()
		instance.title = "Spicy"
		instance.items = ["Hot", "Yes", "No"]
		return instance
	}()

	lazy var drink: SegmentedControlFormItem = {
		let instance = SegmentedControlFormItem()
		instance.title = "Drink"
		instance.items = ["Beer", "Wine"]
		return instance
	}()

	lazy var popcorn: SegmentedControlFormItem = {
		let instance = SegmentedControlFormItem()
		instance.title = "Popcorn"
		instance.items = ["S", "M", "XL", "XXL"]
		instance.selected = 3
		return instance
	}()

	lazy var submitButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Place order"
		instance.action = { [weak self] in
			if let actualSelf = self {
				actualSelf.form_simpleAlert("My Receipt", actualSelf.receipt)
			}
		}
		return instance
	}()

	var receipt: String {
		var s = "Animal: \(animal.selectedItem!), $180\n"
		s += "Spicy: \(spicy.selectedItem!), $1\n"
		s += "Drink: \(drink.selectedItem!), $30\n"
		s += "Popcorn: \(popcorn.selectedItem!), $100\n"
		s += "---\nTotal: $311 USD"
		return s
	}

	lazy var randomizeButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Randomize"
		instance.action = { [weak self] in
			self?.randomize()
		}
		return instance
	}()

	func assignRandomValue(_ formItem: SegmentedControlFormItem) {
		let count = formItem.items.count
		if count > 0 {
			formItem.selected = randomInt(0, count - 1)
		}
	}

	func randomize() {
		assignRandomValue(animal)
		assignRandomValue(spicy)
		assignRandomValue(drink)
		assignRandomValue(popcorn)
	}
}
