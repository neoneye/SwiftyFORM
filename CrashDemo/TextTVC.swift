//
//  TextTVC.swift
//  Katerra-Forms
//
//  Created by Alexey Bondarchuk on 10/25/16.
//  Copyright © 2016 Katerra Inc. All rights reserved.
//

import UIKit
import SwiftyFORM

class TextTVC: UITableViewCell, UITextFieldDelegate {
//class TextTVC: UITableViewCell, UITextFieldDelegate, CellHeightProvider {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var validationImage: UIImageView!
    
    var xibHeight: CGFloat = 44
    
    static func createCell() throws -> TextTVC {
        let cell: TextTVC = try Bundle.main.form_loadView("TextTVC")
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        xibHeight = bounds.height
        textField.delegate = self

    }
    
    func validate(value:String) {
        //If `Property name` is empty -> Disable Save button
        if value.characters.count > 0 {
            validationImage.isHidden = true
        } else {
            validationImage.isHidden = false
        }
    }
    
//    public func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
//        return xibHeight
//    }
	
    public typealias TextDidChangeBlock = (_ value: String) -> Void
    public var textDidChangeBlock: TextDidChangeBlock = { (value: String) in
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textDidChangeBlock("")
        validate(value:"")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.isEmpty)! && string == " " {
            return false
        }
        
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)

        textDidChangeBlock(resultString)
        validate(value:resultString)
        
        return true
    }
    
}
