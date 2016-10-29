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
        builder += topTitle
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
    
    //MARK: - BUILDER -
	
	func createSpaceView() -> FormItem {
		let headerView = SectionHeaderViewFormItem()
		headerView.viewBlock = {
			return InfoView(frame: CGRect(x: 0, y: 0, width: 100, height: 3), text: " ")
		}
		return headerView
	}
	
    lazy var topTitle: SectionHeaderTitleFormItem = {
        let instance = SectionHeaderTitleFormItem()
        instance.title = "I HEREBY CERTIFY THAT THE AGREED UPON SCOPE OF WORK HAS BEEN SATISFIED, AND I AM ACCEPTING THE TURNOVER OF THIS UNIT."
        return instance
    }()
    
	
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
