// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
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
		
		dataSource = formBuilder.result(self)
		self.tableView.dataSource = dataSource
		self.tableView.delegate = dataSource
		
		debugPrint(dataSource!)
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
}
