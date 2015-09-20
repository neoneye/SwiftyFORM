// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public enum WhatToShow {
	case Json(json: NSData)
	case Text(text: String)
	case Url(url: NSURL)
}

/*
Usage:
DebugViewController.showURL(self, url: NSURL(string: "http://www.google.com")!)
DebugViewController.showText(self, text: "hello world")
*/
public class DebugViewController: UIViewController {
	
	public let dismissBlock: Void -> Void
	public let whatToShow: WhatToShow
	
	public init(dismissBlock: Void -> Void, whatToShow: WhatToShow) {
		self.dismissBlock = dismissBlock
		self.whatToShow = whatToShow
		super.init(nibName: nil, bundle: nil)
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	public class func showJSON(parentViewController: UIViewController, jsonData: NSData) {
		showModally(parentViewController, whatToShow: WhatToShow.Json(json: jsonData))
	}

	public class func showText(parentViewController: UIViewController, text: String) {
		showModally(parentViewController, whatToShow: WhatToShow.Text(text: text))
	}

	public class func showURL(parentViewController: UIViewController, url: NSURL) {
		showModally(parentViewController, whatToShow: WhatToShow.Url(url: url))
	}
	
	
	public class func showModally(parentViewController: UIViewController, whatToShow: WhatToShow) {
		weak var weakSelf = parentViewController
		let dismissBlock: Void -> Void = {
			if let vc = weakSelf {
				vc.dismissViewControllerAnimated(true, completion: nil)
			}
		}
		
		let vc = DebugViewController(dismissBlock: dismissBlock, whatToShow: whatToShow)
		let nc = UINavigationController(rootViewController: vc)
		parentViewController.presentViewController(nc, animated: true, completion: nil)
	}

	public override func loadView() {
		let webview = UIWebView()
		self.view = webview
		
		let item = UIBarButtonItem(title: "Dismiss", style: .Plain, target: self, action: "dismissAction:")
		self.navigationItem.leftBarButtonItem = item

		switch whatToShow {
		case let .Json(json):
			let url = NSURL(string: "http://localhost")!
			webview.loadData(json, MIMEType: "application/json", textEncodingName: "utf-8", baseURL: url)
			self.title = "JSON"
		case let .Text(text):
			let url = NSURL(string: "http://localhost")!
			let data = (text as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
			webview.loadData(data, MIMEType: "text/plain", textEncodingName: "utf-8", baseURL: url)
			self.title = "Text"
		case let .Url(url):
			let request = NSURLRequest(URL: url)
			webview.loadRequest(request)
			self.title = "URL"
		}
	}
	
	func dismissAction(sender: AnyObject?) {
		dismissBlock()
	}

}
