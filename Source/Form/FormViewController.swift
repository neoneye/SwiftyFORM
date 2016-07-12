// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public class FormViewController: UIViewController {
	public var dataSource: TableViewSectionArray?
	public var keyboardHandler: KeyboardHandler?
	
	public init() {
		SwiftyFormLog("super init")
		super.init(nibName: nil, bundle: nil)
	}
	
	required public init(coder aDecoder: NSCoder) {
		SwiftyFormLog("super init")
		super.init(nibName: nil, bundle: nil)
	}

	override public func loadView() {
		SwiftyFormLog("super loadview")
		view = tableView
		
		keyboardHandler = KeyboardHandler(tableView: tableView)
		
		populate(formBuilder)
		title = formBuilder.navigationTitle
		
		dataSource = formBuilder.result(viewController: self, tableView: tableView)
		self.tableView.dataSource = dataSource
		self.tableView.delegate = dataSource
	}

	public func populate(builder: FormBuilder) {
		SwiftyFormLog("subclass must implement populate()")
	}

	override public func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		keyboardHandler?.addObservers()

		// Fade out, so that the user can see what row has been updated
		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
	}
	
	override public func viewDidDisappear(animated: Bool) {
		self.keyboardHandler?.removeObservers()
		super.viewDidDisappear(animated)
	}

	public lazy var formBuilder: FormBuilder = {
		return FormBuilder()
		}()
	
	public lazy var tableView: FormTableView = {
		return FormTableView()
		}()
	
	func expandCollapse(cell cell: PrecisionSliderCell, expandedCell: PrecisionSliderCellExpanded, indexPath: NSIndexPath) {
		guard let dataSource = dataSource else {
			SwiftyFormLog("cannot expand row. The dataSource is nil")
			return
		}
		
		if indexPath.section >= dataSource.sections.count {
			SwiftyFormLog("cannot expand row. The indexPath.section is out of range")
			return
		}

		guard let section = dataSource.sections[indexPath.section] as? TableViewSection else {
			SwiftyFormLog("cannot expand row. The indexPath.section has the wrong type")
			return
		}

		SwiftyFormLog("will expand")

		var insertion = [NSIndexPath]()
		var deletion = [NSIndexPath]()
		
		var row = 0
		for c in section.cells.cells {
			
			if c.cell === expandedCell {
				if c.hidden {
					c.hidden = false
					section.cells.reloadVisibleCells()
					insertion.append(NSIndexPath(forRow: row, inSection: indexPath.section))
					break
				} else {
					c.hidden = true
					section.cells.reloadVisibleCells()
					deletion.append(NSIndexPath(forRow: row, inSection: indexPath.section))
				}
			}
			
			if c.hidden {
				continue
			}
			row += 1
		}

		tableView.beginUpdates()
		tableView.deleteRowsAtIndexPaths(deletion, withRowAnimation: .Fade)
		tableView.insertRowsAtIndexPaths(insertion, withRowAnimation: .Fade)
		tableView.endUpdates()
		
		SwiftyFormLog("did expand")
	}
}
