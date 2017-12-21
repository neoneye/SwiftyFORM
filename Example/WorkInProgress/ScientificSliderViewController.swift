// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import SwiftyFORM

class ScientificSliderViewController: UIViewController {
	override func loadView() {
		super.loadView()
		view.backgroundColor = UIColor.lightGray
		view.addSubview(focusView)
		view.addSubview(label)
		view.addSubview(titleLabel)
		view.addSubview(usageLabel)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		focusView.addGestureRecognizer(panGesture)
		updateLabel()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		focusView.removeGestureRecognizer(panGesture)
	}

	lazy var panGesture: UIPanGestureRecognizer = {
		let instance = UIPanGestureRecognizer(target: self, action: #selector(ScientificSliderViewController.handlePan))
		return instance
	}()

	lazy var focusView: UIView = {
		let instance = UIView()
		instance.backgroundColor = UIColor.white
		return instance
	}()

	lazy var usageLabel: UILabel = {
		let instance = UILabel()
		instance.text = "Pan left/right to adjust magnitude.\n\nPan up/down to adjust value."
		instance.numberOfLines = 0
		instance.textAlignment = .center
		instance.font = UIFont.systemFont(ofSize: 17)
		return instance
	}()

	lazy var titleLabel: UILabel = {
		let instance = UILabel()
		instance.text = "Value"
		instance.numberOfLines = 0
		instance.textAlignment = .left
		instance.font = UIFont.boldSystemFont(ofSize: 18)
		return instance
	}()

	lazy var label: UILabel = {
		let instance = UILabel()
		instance.text = "-"
		instance.numberOfLines = 0
		instance.textAlignment = .right
		instance.font = UIFont.systemFont(ofSize: 20)
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
		for (index, char) in xs.reversed().enumerated() {
			if index >= cutpoint {
				fp = "\(char)\(fp)"
			} else {
				sp = "\(char)\(sp)"
			}
		}

		let firstPart = NSAttributedString(string: fp, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
		let secondPart = NSAttributedString(string: sp, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])

		let text = NSMutableAttributedString()
		text.append(firstPart)
		text.append(secondPart)

		label.attributedText = text
		view.setNeedsLayout()
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		do {
			let frame = view.bounds.insetBy(dx: 10, dy: 80)
			let (f0, _) = frame.divided(atDistance: 200, from: .minYEdge)
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

	@objc func handlePan(_ gesture: UIPanGestureRecognizer) {
		if gesture.state == .began {
			xOriginal = x
			yOriginal = y
			xDelta = 0
			yDelta = 0
		}

		if gesture.state == .changed {
			let translation = gesture.translation(in: gesture.view)
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
			gesture.setTranslation(CGPoint.zero, in: gesture.view)
		}
	}
}
