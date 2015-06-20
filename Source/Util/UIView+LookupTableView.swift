//
//  UIView+LookupTableView.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 25/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit

extension UIView {
	func form_tableView() -> UITableView? {
		var viewOrNil: UIView? = self
		while let view = viewOrNil {
			if let tableView = view as? UITableView {
				return tableView
			}
			viewOrNil = view.superview
		}
		return nil
	}
}