// MIT license. Copyright (c) 2017 SwiftyFORM. All rights reserved.
import UIKit
import MessageUI
import SwiftyFORM

class ReportViewController: FormViewController, MFMailComposeViewControllerDelegate {
	let sendButton = ButtonFormItem()

	override func populate(_ builder: FormBuilder) {
		configureButton()

		builder.navigationTitle = "Report"
		builder.demo_showInfo("Report a problem\nTroubleshooting\nNeed help")
		builder += SectionHeaderTitleFormItem().title("Send report to the developer")
		builder += sendButton
		builder += SectionHeaderTitleFormItem().title("Device info")
		builder += deviceName()
		builder += systemVersion()
		builder += SectionHeaderTitleFormItem().title("App info")
		builder += appName()
		builder += appVersion()
		builder += appBuild()
	}

	func configureButton() {
		sendButton.title = "Send Now!"
		sendButton.action = { [weak self] in
			self?.sendMail()
		}
	}

	static func platformModelString() -> String? {
		if let key = "hw.machine".cString(using: String.Encoding.utf8) {
			var size: Int = 0
			sysctlbyname(key, nil, &size, nil, 0)
			var machine = [CChar](repeating: 0, count: Int(size))
			sysctlbyname(key, &machine, &size, nil, 0)
			return String(cString: machine)
		}
		return nil
	}

	func deviceName() -> StaticTextFormItem {
		let string = ReportViewController.platformModelString() ?? "N/A"
		return StaticTextFormItem().title("Device").value(string)
	}

	func systemVersion() -> StaticTextFormItem {
		let string: String = UIDevice.current.systemVersion
		return StaticTextFormItem().title("iOS").value(string)
	}

	func appName() -> StaticTextFormItem {
		let mainBundle = Bundle.main
		let string0 = mainBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
		let string1 = mainBundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
		let string = string0 ?? string1 ?? "Unknown"
		return StaticTextFormItem().title("Name").value(string)
	}

	func appVersion() -> StaticTextFormItem {
		let mainBundle = Bundle.main
		let string0 = mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
		let string = string0 ?? "Unknown"
		return StaticTextFormItem().title("Version").value(string)
	}

	func appBuild() -> StaticTextFormItem {
		let mainBundle = Bundle.main
		let string0 = mainBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
		let string = string0 ?? "Unknown"
		return StaticTextFormItem().title("Build").value(string)
	}

	func sendMail() {
		if MFMailComposeViewController.canSendMail() {
			let mc = configuredMailComposeViewController()
			present(mc, animated: true, completion: nil)
		} else {
			form_simpleAlert("Could Not Send Mail", "Your device could not send mail. Please check mail configuration and try again.")
		}
	}

	func configuredMailComposeViewController() -> MFMailComposeViewController {
		let emailTitle = "Report"
		let messageBody = "This is a test email body"
		let toRecipents = ["feedback@example.com"]

		let mc = MFMailComposeViewController()
		mc.mailComposeDelegate = self
		mc.setSubject(emailTitle)
		mc.setMessageBody(messageBody, isHTML: false)
		mc.setToRecipients(toRecipents)
		return mc
	}

	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		dismiss(animated: false) { [weak self] in
			self?.showMailResultAlert(result, error: error)
		}
	}

	func showMailResultAlert(_ result: MFMailComposeResult, error: Error?) {
		switch result {
		case .cancelled:
			form_simpleAlert("Status", "Mail cancelled")
		case .saved:
			form_simpleAlert("Status", "Mail saved")
		case .sent:
			form_simpleAlert("Status", "Mail sent")
		case .failed:
			form_simpleAlert("Mail failed", "error: \(String(describing: error))")
		}
	}
}
