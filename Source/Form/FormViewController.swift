// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public class FormViewController: UIViewController {
	public var dataSource: TableViewSectionArray?
	public var keyboardHandler: KeyboardHandler?
	
	public init() {
		DLog("super init")
		super.init(nibName: nil, bundle: nil)
	}
	
	required public init(coder aDecoder: NSCoder) {
		DLog("super init")
		super.init(nibName: nil, bundle: nil)
	}

	override public func loadView() {
		DLog("super loadview")
		self.view = self.tableView
		
		keyboardHandler = KeyboardHandler(tableView: self.tableView)
		
		self.populate(formBuilder)
		self.title = formBuilder.navigationTitle
		
		dataSource = formBuilder.result(self)
		self.tableView.dataSource = dataSource
		self.tableView.delegate = dataSource
	}

	public func populate(builder: FormBuilder) {
		DLog("subclass must implement populate()")
	}

	override public func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.keyboardHandler?.addObservers()

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
