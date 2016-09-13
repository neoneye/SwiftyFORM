// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

extension UIViewController {
	public func form_simpleAlert(_ title: String, _ message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}
