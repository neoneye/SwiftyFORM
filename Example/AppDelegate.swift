// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
		let vc = FirstViewController()
		let window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window.rootViewController = UINavigationController(rootViewController: vc)
		window.tintColor = nil
		self.window = window
		window.makeKeyAndVisible()
		return true
	}
	
}
