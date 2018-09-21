// MIT license. Copyright (c) 2018 SwiftyFORM. All rights reserved.
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
		
		builder += SectionHeaderTitleFormItem().title("App info")
		builder += StaticTextFormItem().title("Name").value(AppInfo.appName)
		builder += StaticTextFormItem().title("Version").value(AppInfo.appVersionAndBuild)
		builder += StaticTextFormItem().title("UTC").value(AppInfo.packageDate)
		builder += StaticTextFormItem().title("Defines").value(AppInfo.defines)

		builder += SectionHeaderTitleFormItem().title("Device info")
		builder += StaticTextFormItem().title("Device").value(AppInfo.deviceName)
		builder += StaticTextFormItem().title("iOS").value(AppInfo.systemVersion)
	}

	func configureButton() {
		sendButton.title = "Send Now!"
		sendButton.action = { [weak self] in
			self?.sendMail()
		}
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
		let emailTitle = "SwiftyFORM feedback"
		let messageBody = "Insert a message to the user of your app, or write to the SwiftyFORM developer.\n---------\n\n\nHi Simon (the SwiftyFORM developer),\n\nI use your framework in my app.\n\nBest regards from Antarctica"
		let toRecipents = ["neoneye@gmail.com"]

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

struct AppInfo {
	static var buildDate: Date? {
		guard let infoPath = Bundle.main.path(forResource: "Info.plist", ofType: nil) else {
			return nil
		}
		guard let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath) else {
			return nil
		}
		let key = FileAttributeKey(rawValue: "NSFileCreationDate")
		guard let infoDate = infoAttr[key] as? Date else {
			return nil
		}
		return infoDate
	}
	
	static var packageDate: String {
		guard let date = buildDate else {
			return "Unknown"
		}
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		return formatter.string(from: date)
	}
	
	static var deviceName: String {
		if let key = "hw.machine".cString(using: String.Encoding.utf8) {
			var size: Int = 0
			sysctlbyname(key, nil, &size, nil, 0)
			var machine = [CChar](repeating: 0, count: Int(size))
			sysctlbyname(key, &machine, &size, nil, 0)
			return String(cString: machine)
		}
		return "Unknown"
	}
	
	static var appName: String {
		let mainBundle = Bundle.main
		let string0 = mainBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
		let string1 = mainBundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
		let string = string0 ?? string1 ?? "Unknown"
		return string
	}
	
	static var appVersion: String {
		let mainBundle = Bundle.main
		let string0 = mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
		let string = string0 ?? "Unknown"
		return string
	}
	
	static var appBuild: String {
		let mainBundle = Bundle.main
		let string0 = mainBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
		let string = string0 ?? "Unknown"
		return string
	}
	
	static var appVersionAndBuild: String {
		return "\(appVersion), build \(appBuild)"
	}
	
	static var systemVersion: String {
		return UIDevice.current.systemVersion
	}
	
	static var defines: String {
		var strings = [String]()
		#if DEBUG
			strings.append("DEBUG")
		#endif
		#if RELEASE
			strings.append("RELEASE")
		#endif
		if strings.isEmpty {
			return "N/A"
		}
		return strings.joined(separator: ", ")
	}
}
