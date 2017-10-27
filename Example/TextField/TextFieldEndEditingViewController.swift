// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class TextFieldEndEditingViewController: FormViewController {
    lazy var textFieldEx:TextFieldFormItem = {
        var instance = TextFieldFormItem()
        instance.title = "Title"
        instance.keyboardType = .numbersAndPunctuation
        instance.autocorrectionType = .no
        instance.textEditingEndBlock = {
            [weak self] val in
            let alert = UIAlertController(title: "End Editing", message: "Value is \(val)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }
        return instance
    }()
    
    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "Editing End"
        builder.toolbarMode = .simple
        builder.demo_showInfo("Shows an alert after editing finish")
        builder += SectionHeaderTitleFormItem().title("Editing End")
        builder += textFieldEx
    }
}
