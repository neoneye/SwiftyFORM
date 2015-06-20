//
//  ButtonsViewController.swift
//  Example
//
//  Created by Simon Strandgaard on 20-06-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import UIKit
import SwiftyFORM

class ButtonsViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder.navigationTitle = "Buttons"
		builder.toolbarMode = .None
		builder += SectionHeaderTitleFormItem().title("Table Row Buttons")
		builder += button0
		builder += button1
		builder += button2
	}
	
	lazy var button0: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Button 0")
		instance.action = { [weak self] in
			self?.form_simpleAlert("Button 0", "Button clicked")
		}
		return instance
		}()
	
	lazy var button1: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Button 1")
		instance.action = { [weak self] in
			self?.form_simpleAlert("Button 1", "Button clicked")
		}
		return instance
		}()
	
	lazy var button2: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Button 2")
		instance.action = { [weak self] in
			self?.form_simpleAlert("Button 2", "Button clicked")
		}
		return instance
		}()
}
