// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class ButtonsViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Buttons"
		builder.toolbarMode = .none
		builder += SectionHeaderTitleFormItem().title("Simple Buttons")
		builder += button0
		builder += button1
		builder += button2
        builder += SectionHeaderTitleFormItem().title("Themed Buttons")
        builder += button3
        builder += button4
	}

	lazy var button0: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Button 0"
		instance.action = { [weak self] in
			self?.form_simpleAlert("Button 0", "Button clicked")
		}
		return instance
	}()

	lazy var button1: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Button 1"
		instance.action = { [weak self] in
			self?.form_simpleAlert("Button 1", "Button clicked")
		}
		return instance
	}()

	lazy var button2: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Button 2"
		instance.action = { [weak self] in
			self?.form_simpleAlert("Button 2", "Button clicked")
		}
		return instance
	}()

    lazy var button3: ButtonFormItem = {
        let instance = ButtonFormItem()
        instance.title = "Button 3"
        instance.titleTextColor = UIColor.black
        instance.backgroundColor = UIColor.yellow
        instance.action = { [weak self] in
            self?.form_simpleAlert("Button 3", "Button clicked")
        }
        return instance
    }()

    lazy var button4: ButtonFormItem = {
        let instance = ButtonFormItem()
        instance.title = "Button 4"
        instance.titleTextColor = UIColor.black
        instance.backgroundColor = UIColor.red
        instance.action = { [weak self] in
            self?.form_simpleAlert("Button 4", "Button clicked")
        }
        return instance
    }()
}
