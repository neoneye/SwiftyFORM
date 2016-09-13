// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

public enum WhatToShow {
	case json(json: Data)
	case text(text: String)
	case url(url: URL)
}

/*
Usage:
DebugViewController.showURL(self, url: NSURL(string: "http://www.google.com")!)
DebugViewController.showText(self, text: "hello world")
*/
open class DebugViewController: UIViewController {
	
	open let dismissBlock: (Void) -> Void
	open let whatToShow: WhatToShow
	
	public init(dismissBlock: @escaping (Void) -> Void, whatToShow: WhatToShow) {
		self.dismissBlock = dismissBlock
		self.whatToShow = whatToShow
		super.init(nibName: nil, bundle: nil)
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	open class func showJSON(_ parentViewController: UIViewController, jsonData: Data) {
		showModally(parentViewController, whatToShow: WhatToShow.json(json: jsonData))
	}

	open class func showText(_ parentViewController: UIViewController, text: String) {
		showModally(parentViewController, whatToShow: WhatToShow.text(text: text))
	}

	open class func showURL(_ parentViewController: UIViewController, url: URL) {
		showModally(parentViewController, whatToShow: WhatToShow.url(url: url))
	}
	
	
	open class func showModally(_ parentViewController: UIViewController, whatToShow: WhatToShow) {
		weak var weakSelf = parentViewController
		let dismissBlock: (Void) -> Void = {
			if let vc = weakSelf {
				vc.dismiss(animated: true, completion: nil)
			}
		}
		
		let vc = DebugViewController(dismissBlock: dismissBlock, whatToShow: whatToShow)
		let nc = UINavigationController(rootViewController: vc)
		parentViewController.present(nc, animated: true, completion: nil)
	}

	open override func loadView() {
		let webview = UIWebView()
		self.view = webview
		
		let item = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(DebugViewController.dismissAction(_:)))
		self.navigationItem.leftBarButtonItem = item

		switch whatToShow {
		case let .json(json):
			let url = URL(string: "http://localhost")!
			webview.load(json, mimeType: "application/json", textEncodingName: "utf-8", baseURL: url)
			self.title = "JSON"
		case let .text(text):
			let url = URL(string: "http://localhost")!
			let data = (text as NSString).data(using: String.Encoding.utf8.rawValue)!
			webview.load(data, mimeType: "text/plain", textEncodingName: "utf-8", baseURL: url)
			self.title = "Text"
		case let .url(url):
			let request = URLRequest(url: url)
			webview.loadRequest(request)
			self.title = "URL"
		}
	}
	
	func dismissAction(_ sender: AnyObject?) {
		dismissBlock()
	}

}
