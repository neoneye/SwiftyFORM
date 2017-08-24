// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

class MyTableViewController: UITableViewController {
	override init(style: UITableViewStyle) {
		super.init(style: .grouped)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
		cell.textLabel?.text = "Cell \(indexPath.row)"
		return cell
	}
}
