// MIT license. Copyright (c) 2020 SwiftyFORM. All rights reserved.
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /* `insetGrouped` is new with iOS >=13, just use `grouped` or `plain` for iOS <12
            the default style is `grouped` */
        let vc = FirstViewController(style: .insetGrouped)
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = UINavigationController(rootViewController: vc)
		window.tintColor = nil
		self.window = window
		window.makeKeyAndVisible()
		return true
	}

}
