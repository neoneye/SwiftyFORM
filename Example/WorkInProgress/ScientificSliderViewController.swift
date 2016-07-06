// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class ScientificSliderViewController: UIViewController {
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.lightGrayColor()
		view.addSubview(focusView)
		view.addSubview(label)
		view.addSubview(titleLabel)
		view.addSubview(usageLabel)
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
	
	lazy var usageLabel: UILabel = {
		let instance = UILabel()
		instance.text = "Pan left/right to adjust magnitude.\n\nPan up/down to adjust value."
		instance.numberOfLines = 0
		instance.textAlignment = .Center
		instance.font = UIFont.systemFontOfSize(17)
		return instance
	}()
	
	lazy var titleLabel: UILabel = {
		let instance = UILabel()
		instance.text = "Value"
		instance.numberOfLines = 0
		instance.textAlignment = .Left
		instance.font = UIFont.boldSystemFontOfSize(18)
		return instance
	}()
	
	lazy var label: UILabel = {
		let instance = UILabel()
		instance.text = "-"
		instance.numberOfLines = 0
		instance.textAlignment = .Right
		instance.font = UIFont.systemFontOfSize(20)
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
		
		label.attributedText = text
		view.setNeedsLayout()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		do {
			let frame = view.bounds.insetBy(dx: 10, dy: 80)
			let (f0, _) = frame.divide(200, fromEdge: .MinYEdge)
			usageLabel.frame = f0
		}
		
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
	
	func handlePan(gesture: UIPanGestureRecognizer) {
		if gesture.state == .Began {
			xOriginal = x
			yOriginal = y
			xDelta = 0
			yDelta = 0
		}
		
		if gesture.state == .Changed {
			let translation = gesture.translationInView(gesture.view)
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
