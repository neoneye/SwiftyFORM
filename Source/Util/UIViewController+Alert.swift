// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

extension UIViewController {
	public func form_simpleAlert(title: String, _ message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}
}
