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
	
	var x: CGFloat = 0
	var y: Int = 0
	
	func updateLabel() {
		let xs = String(format: "%.3f", x)
		var magnitude = ""
		switch y {
		case -3: magnitude = "0.001"
		case -2: magnitude = "0.010"
		case -1: magnitude = "0.100"
		case  0: magnitude = "1.000"
		case  1: magnitude = "10.000"
		case  2: magnitude = "100.000"
		case  3: magnitude = "1000.000"
		default:
			magnitude = ""
		}
		label.text = "\(xs)\n\(magnitude)\n\(y)"
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
	
	var xOriginal: CGFloat = 0
	var yOriginal: Int = 0

	var xDelta: CGFloat = 0
	var yDelta: CGFloat = 0
	
	var counter = 0
	func handlePan(gesture: UIPanGestureRecognizer) {
//		print("! \(counter)")
		counter += 1
		
		if gesture.state == .Began {
			xOriginal = x
			yOriginal = y
			xDelta = 0
			yDelta = 0
		}
		
		if gesture.state == .Changed {
			let translation = gesture.translationInView(gesture.view)
//			print("x: \(translation.x)")
			xDelta += translation.x
			yDelta -= translation.y
						
			if y == -3 {
				x = xOriginal + xDelta / 1000.0
			}
			if y == -2 {
				x = xOriginal + xDelta / 100.0
			}
			if y == -1 {
				x = xOriginal + xDelta / 10.0
			}
			if y == 0 {
				x = xOriginal + xDelta
			}
			if y == 1 {
				x = xOriginal + xDelta * 10.0
			}
			if y == 2 {
				x = xOriginal + xDelta * 100.0
			}
			if y == 3 {
				x = xOriginal + xDelta * 1000.0
			}
			
			y = yOriginal + Int(yDelta / 50.0)
			if y < -3 {
				y = -3
			}
			if y > 3 {
				y = 3
			}
			
			if y != yOriginal {
				yOriginal = y
				yDelta = 0
				xOriginal = x
				xDelta = 0
			}
			
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
