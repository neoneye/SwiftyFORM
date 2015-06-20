//
//  Dictionary+Update.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 22/11/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import Foundation

extension Dictionary {
	/// merge two dictionaries into one dictionary
	mutating func update(other:Dictionary) {
		for (key,value) in other {
			self.updateValue(value, forKey:key)
		}
	}
}
