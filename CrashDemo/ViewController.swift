//
//  ViewController.swift
//  CrashDemo
//
//  Created by Alexey Bondarchuk on 10/26/16.
//  Copyright © 2016 Faifly, LLC. All rights reserved.
//

import SwiftyFORM

class ViewController: FormViewController {
	
    override func populate(_ builder: FormBuilder) {
        builder += SectionHeaderTitleFormItem(title: "hello")
        builder += StaticTextFormItem().title("a")
        builder += createSpaceView()
        builder += StaticTextFormItem().title("b")
        builder += createSpaceView()
        builder += StaticTextFormItem().title("c")
		builder += StaticTextFormItem().title("d")
        builder += StaticTextFormItem().title("e")
        builder += createSpaceView()
        builder += StaticTextFormItem().title("f")
        builder += createSpaceView()
        builder += StaticTextFormItem().title("g")
        builder += createSpaceView()
		//-----
        builder += datePicker
		//-----
        builder += createSpaceView()
        builder += StaticTextFormItem().title("x")
        builder += createSpaceView()
        builder += StaticTextFormItem().title("y")
        builder += createSpaceView()
        builder += StaticTextFormItem().title("z")
    }
    
	func createSpaceView() -> FormItem {
		let headerView = SectionHeaderViewFormItem()
		headerView.viewBlock = {
			return InfoView(frame: CGRect(x: 0, y: 0, width: 100, height: 3), text: " ")
		}
		return headerView
	}
	
    lazy var datePicker: DatePickerFormItem = {
        let instance = DatePickerFormItem()
        instance.title = "Date of Signing"
        instance.datePickerMode = .date
        instance.behavior = .collapsed
        instance.valueDidChangeBlock = { [weak self] _ in
        
        }
        return instance
    }()
	
}
