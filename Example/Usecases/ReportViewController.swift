// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit
import MessageUI
import SwiftyFORM

class ReportViewController: FormViewController, MFMailComposeViewControllerDelegate {
	let sendButton = ButtonFormItem()
	
	override func populate(builder: FormBuilder) {
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
		sendButton.title("Send Now!")
		sendButton.action = { [weak self] in
			self?.sendMail()
		}
	}
	
	static func platformModelString() -> String? {
		if let key = "hw.machine".cStringUsingEncoding(NSUTF8StringEncoding) {
			var size: Int = 0
			sysctlbyname(key, nil, &size, nil, 0)
			var machine = [CChar](count: Int(size), repeatedValue: 0)
			sysctlbyname(key, &machine, &size, nil, 0)
			return String.fromCString(machine)!
		}
		return nil
	}
	
	func deviceName() -> StaticTextFormItem {
		let string = ReportViewController.platformModelString() ?? "N/A"
		return StaticTextFormItem().title("Device").value(string)
	}
	
	func systemVersion() -> StaticTextFormItem {
		let string: String = UIDevice.currentDevice().systemVersion
		return StaticTextFormItem().title("iOS").value(string)
	}
	
	func appName() -> StaticTextFormItem {
		let mainBundle = NSBundle.mainBundle()
		let string0 = mainBundle.objectForInfoDictionaryKey("CFBundleDisplayName") as? String
		let string1 = mainBundle.objectForInfoDictionaryKey(kCFBundleNameKey as String) as? String
		let string = string0 ?? string1 ?? "Unknown"
		return StaticTextFormItem().title("Name").value(string)
	}
	
	func appVersion() -> StaticTextFormItem {
		let mainBundle = NSBundle.mainBundle()
		let string0 = mainBundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
		let string = string0 ?? "Unknown"
		return StaticTextFormItem().title("Version").value(string)
	}
	
	func appBuild() -> StaticTextFormItem {
		let mainBundle = NSBundle.mainBundle()
		let string0 = mainBundle.objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String
		let string = string0 ?? "Unknown"
		return StaticTextFormItem().title("Build").value(string)
	}
	
	func sendMail() {
		if MFMailComposeViewController.canSendMail() {
			let mc = configuredMailComposeViewController()
			presentViewController(mc, animated: true, completion: nil)
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
	
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		dismissViewControllerAnimated(false) { [weak self] in
			self?.showMailResultAlert(result, error: error)
		}
	}
	
	func showMailResultAlert(result: MFMailComposeResult, error: NSError?) {
		switch result.rawValue {
		case MFMailComposeResultCancelled.rawValue:
			form_simpleAlert("Status", "Mail cancelled")
		case MFMailComposeResultSaved.rawValue:
			form_simpleAlert("Status", "Mail saved")
		case MFMailComposeResultSent.rawValue:
			form_simpleAlert("Status", "Mail sent")
		case MFMailComposeResultFailed.rawValue:
			form_simpleAlert("Mail failed", "error: \(error)")
		default:
			break
		}
	}
}

