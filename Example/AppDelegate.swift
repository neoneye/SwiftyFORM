// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

class SliderGestureViewController: UIViewController {
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.lightGrayColor()
		view.addSubview(focusView)
		view.addSubview(label)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		focusView.addGestureRecognizer(panGesture)
		updateLabel()
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		focusView.removeGestureRecognizer(panGesture)
	}
	
	lazy var panGesture: UIPanGestureRecognizer = {
		let instance = UIPanGestureRecognizer(target: self, action: #selector(SliderGestureViewController.handlePan))
		return instance
	}()
	
	lazy var focusView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.redColor()
		return instance
	}()
	
	lazy var label: UILabel = {
		let instance = UILabel()
		instance.text = "-"
		instance.numberOfLines = 0
		instance.textAlignment = .Right
		return instance
	}()
	
	var value: Int = 0
	var changeIndex: Int = 0
	
	func updateLabel() {
		label.text = "\(value)\n\(changeIndex)"
		view.setNeedsLayout()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		var f = view.bounds.insetBy(dx: 40, dy: 10)
		f.size.height = 100
		f.origin.y = view.bounds.midY - 50
		focusView.frame = f
		
		let size = label.sizeThatFits(f.size)
		label.frame = CGRect(origin: CGPointZero, size: size)
		label.center = focusView.center
	}
	
	var originalValue = 0
	var accum: CGFloat = 0
	
	
	var counter = 0
	func handlePan(gesture: UIPanGestureRecognizer) {
//		print("! \(counter)")
		counter += 1
		
		if gesture.state == .Began {
			originalValue = value
			accum = 0
		}
		
		if gesture.state == .Changed {
			let translation = gesture.translationInView(gesture.view)
			print("x: \(translation.x)")
			accum += translation.x
			
			value = originalValue + Int(accum / 10.0)
			updateLabel()
			gesture.setTranslation(CGPointZero, inView: gesture.view)
		}
	}
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//		let vc = FirstViewController()
		let vc = SliderGestureViewController()
		let window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window.rootViewController = UINavigationController(rootViewController: vc)
		window.tintColor = nil
		self.window = window
		window.makeKeyAndVisible()
		return true
	}
	
}
