//
//  Math.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 09/12/14.
//  Copyright (c) 2014 Simon Strandgaard. All rights reserved.
//

import Foundation

public func randomInt(low: Int, _ high: Int) -> Int {
	let diff = high - low + 1
	return Int(arc4random_uniform(UInt32(diff))) + low
}
