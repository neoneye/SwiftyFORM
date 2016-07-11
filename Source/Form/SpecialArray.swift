// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public class SpecialArray {
	let cells: [UITableViewCell]
	
	init(cells: [UITableViewCell]) {
		self.cells = cells
	}
	
	subscript(index: Int) -> UITableViewCell {
		return cells[index]
	}
	
	var count: Int {
		return cells.count
	}
}
