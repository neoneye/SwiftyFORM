// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class TextViewViewController: FormViewController {

	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "TextViews"
		builder += longSummary
		builder += notes
		builder += commentArea
		builder += userDescription
		builder += SectionHeaderTitleFormItem().title("Buttons")
		builder += randomizeButton
		builder += clearButton
	}

	lazy var longSummary: TextViewFormItem = {
		let instance = TextViewFormItem()
		instance.title("Long summary").placeholder("placeholder")
		instance.value = "Lorem ipsum"
		return instance
		}()

	lazy var notes: TextViewFormItem = {
		let instance = TextViewFormItem()
		instance.title("Notes").placeholder("I'm a placeholder")
		return instance
		}()

	lazy var commentArea: TextViewFormItem = {
		let instance = TextViewFormItem()
		instance.title("Comments").placeholder("I'm also a placeholder")
		return instance
		}()

	lazy var userDescription: TextViewFormItem = {
		let instance = TextViewFormItem()
		instance.title("Description").placeholder("Yet another placeholder")
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

	lazy var clearButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Clear"
		instance.action = { [weak self] in
			self?.clear()
		}
		return instance
		}()

	func pickRandom(_ strings: [String]) -> String {
		if strings.count == 0 {
			return ""
		}
		let i = randomInt(0, strings.count - 1)
		return strings[i]
	}

	func appendRandom(_ textView: TextViewFormItem, strings: [String]) {
		let notEmpty = textView.value.utf8.count != 0
		var s = ""
		if notEmpty {
			s = " "
		}
		textView.value += s + pickRandom(strings)
	}

	func randomize() {
		appendRandom(longSummary, strings: ["Hello", "World", "Cat", "Water", "Fish", "Hund"])
		appendRandom(notes, strings: ["Hat", "Ham", "Has"])
		commentArea.value += pickRandom(["a", "b", "c"])
		userDescription.value += pickRandom(["x", "y", "z", "w"])
	}

	func clear() {
		longSummary.value = ""
		notes.value = ""
		commentArea.value = ""
		userDescription.value = ""
	}
}
