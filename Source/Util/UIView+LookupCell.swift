//
//  UIView+LookupCell.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 01/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit

extension UIView {
	func form_cell() -> UITableViewCell? {
		var viewOrNil: UIView? = self
		while let view = viewOrNil {
			if let cell = view as? UITableViewCell {
				return cell
			}
			viewOrNil = view.superview
		}
		return nil
	}
}
