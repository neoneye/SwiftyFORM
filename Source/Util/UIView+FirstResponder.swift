//
//  UIView+FirstResponder.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 29/10/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import UIKit

extension UIView {
	func form_firstResponder() -> UIView? {
		if self.isFirstResponder() {
			return self
		}
		for subview in subviews {
			let responder = subview.form_firstResponder()
			if responder != nil {
				return responder
			}
		}
		return nil
	}
}
