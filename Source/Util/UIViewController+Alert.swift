// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit

extension UIViewController {
	/// Show an alert with an OK button
	///
	/// - parameter title: The text shown in top of the alert.
	/// - parameter message: The text shown in center of the alert.
	public func form_simpleAlert(_ title: String, _ message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}
