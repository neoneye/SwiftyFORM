// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit


/*
TODO: horizontal pan skal ikke ændre på tal som er mindre end magnifier.. alle tal i second part skal være låst.
TODO: istedetfor vertical pan for at ændre på magnifier, så brug force touch eller long press
TODO: double tap to switch to textfield mode
*/
class SliderGestureViewController: UIViewController {
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.lightGrayColor()
		view.addSubview(focusView)
		view.addSubview(label)
		view.addSubview(titleLabel)
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
		instance.backgroundColor = UIColor.whiteColor()
		return instance
	}()
	
	lazy var titleLabel: UILabel = {
		let instance = UILabel()
		instance.text = "Value"
		instance.numberOfLines = 0
		instance.textAlignment = .Left
		instance.font = UIFont.boldSystemFontOfSize(18)
//		instance.font = UIFont(name: "Menlo-Regular", size: 18)
		return instance
	}()
	
	lazy var label: UILabel = {
		let instance = UILabel()
		instance.text = "-"
		instance.numberOfLines = 0
		instance.textAlignment = .Right
		instance.font = UIFont.systemFontOfSize(20)
//		instance.font = UIFont(name: "Menlo-Regular", size: 18)
		return instance
	}()
	
	var x: Int = 0
	var y: Int = 0
	
	let scale: Int = 3
	
	func updateLabel() {
		let xx = CGFloat(x) * 0.001
		
		let xs: String
		if y >= 6 {
			xs = String(format: "%08.3f", xx)
		} else {
			if y >= 5 {
				xs = String(format: "%07.3f", xx)
			} else {
				if y >= 4 {
					xs = String(format: "%06.3f", xx)
				} else {
					xs = String(format: "%.3f", xx)
				}
			}
		}
		
//		let xs = String(format: "%08.3f", xx)
		
		var cutpoint = y
		if y >= scale {
			cutpoint += 1
		}
		var fp = ""
		var sp = ""
		for (index, char) in xs.characters.reverse().enumerate() {
			if index >= cutpoint {
				fp = "\(char)\(fp)"
			} else {
				sp = "\(char)\(sp)"
			}
		}

		let firstPart = NSAttributedString(string: fp, attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
		let secondPart = NSAttributedString(string: sp, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
		
		let text = NSMutableAttributedString()
		text.appendAttributedString(firstPart)
		text.appendAttributedString(secondPart)

		
//		var magnitude = ""
//		switch y {
//		case 0: magnitude = "0.001"
//		case 1: magnitude = "0.010"
//		case 2: magnitude = "0.100"
//		case 3: magnitude = "1.000"
//		case 4: magnitude = "10.000"
//		case 5: magnitude = "100.000"
//		case 6: magnitude = "1000.000"
//		default:
//			magnitude = ""
//		}
//		label.text = "\(xs)\n\(magnitude)\n\(y)"
		label.attributedText = text
		view.setNeedsLayout()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		var f = view.bounds.insetBy(dx: 0, dy: 10)
		f.size.height = 64
		f.origin.y = view.bounds.midY - 50
		focusView.frame = f
		
		do {
			let size = titleLabel.sizeThatFits(f.size)
			let labelx = f.minX + 20
			let labely = f.midY - size.height / 2
			titleLabel.frame = CGRect(origin: CGPoint(x: labelx, y: labely), size: size)
		}
		do {
			let size = label.sizeThatFits(f.size)
			let labelx = f.maxX - size.width - 20
			let labely = f.midY - size.height / 2
			label.frame = CGRect(origin: CGPoint(x: labelx, y: labely), size: size)
		}
	}
	
	var xOriginal: Int = 0
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
			xDelta -= translation.y * 0.1
			yDelta -= translation.x * 0.05
			
			let xd = Int(floor(xDelta + 0.5))
			let scale = Int(pow(Float(10), Float(y)))
			x = xOriginal + xd * scale
			
			y = yOriginal + Int(yDelta)
			if y < 0 {
				y = 0
			}
			if y > 6 {
				y = 6
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
