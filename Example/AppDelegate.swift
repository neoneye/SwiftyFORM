// MIT license. Copyright (c) 2021 SwiftyFORM. All rights reserved.
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let vc: FirstViewController
        if #available(iOS 13.0, *) {
            // `insetGrouped` is new with iOS >=13
            vc = FirstViewController(style: .insetGrouped)
        } else {
            vc = FirstViewController()
        }
        
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = UINavigationController(rootViewController: vc)
		window.tintColor = nil
		self.window = window
		window.makeKeyAndVisible()
		return true
	}

}
