<h3 align="center">
<a href="https://github.com/neoneye/SwiftyFORM">
<img src="Documentation/swiftyform_logo.png" alt="SwiftyFORM by Simon Strandgaard"/>
<br />
SwiftyFORM
</a>
</h3>

---

[![Build Status](https://travis-ci.org/neoneye/SwiftyFORM.svg?branch=master)](https://travis-ci.org/neoneye/SwiftyFORM)
[![Version](https://img.shields.io/cocoapods/v/SwiftyFORM.svg?style=flat)](http://cocoapods.org/pods/SwiftyFORM)
[![License](https://img.shields.io/cocoapods/l/SwiftyFORM.svg?style=flat)](http://cocoapods.org/pods/SwiftyFORM)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyFORM.svg?style=flat)](http://cocoapods.org/pods/SwiftyFORM)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


**SwiftyFORM is an iOS framework for creating forms.**

Because form code is hard to write, hard to read, hard to reason about. Has a slow turn around time. Is painful to maintain.

[SwiftyFORM demo on YouTube](https://youtu.be/PKbVJ91uQdA)

Development happens in the [`develop`](https://github.com/neoneye/SwiftyFORM/tree/develop) branch.


## Requirements

- iOS 9.0+
- Xcode 8.3.1+
- Swift 3.1+


## Features

- [x] Several form items, such as textfield, buttons, sliders
- [x] Some form items can expand/collapse, such as datepicker, pickerview
- [x] You can create your own custom form items
- [x] Align textfields across multiple rows
- [x] Form validation rule engine
- [x] Shows with red text where there are problems with validation
- [x] Strongly Typed
- [x] Pure Swift
- [x] No 3rd party dependencies


# USAGE

### Tutorial 0 - Static text

```swift
import SwiftyFORM
class MyViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder += StaticTextFormItem().title("Hello").value("World")
	}
}
```

### Tutorial 1 - TextField

```swift
import SwiftyFORM
class MyViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder += TextFieldFormItem().title("Email").placeholder("Please specify").keyboardType(.emailAddress)
	}
}
```

### Tutorial 2 - Open child view controller

```swift
import SwiftyFORM
class MyViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder += ViewControllerFormItem().title("Go to view controller").viewController(FirstViewController.self)
	}
}
```

### Advanced - date picker

![DatePicker with prev button and next button](https://github.com/neoneye/SwiftyFORM/raw/master/Documentation/datepicker_nextprev.jpg "DatePicker with prev button and next button")

```swift
class DatePickerBindingViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder += datePicker
		builder += incrementButton
		builder += decrementButton
		builder += SectionFormItem()
		builder += summary
		updateSummary()
	}
	
	lazy var datePicker: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title = "Date"
		instance.datePickerMode = .date
		instance.behavior = .expandedAlways
		instance.valueDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
		}
		return instance
	}()
	
	lazy var incrementButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Next Day"
		instance.action = { [weak self] in
			self?.increment()
		}
		return instance
	}()
	
	lazy var decrementButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title = "Previous Day"
		instance.action = { [weak self] in
			self?.decrement()
		}
		return instance
	}()
	
	lazy var summary: StaticTextFormItem = {
		return StaticTextFormItem().title("Date").value("-")
	}()
	
	func updateSummary() {
		summary.value = "\(datePicker.value)"
	}
	
	func offsetDate(_ date: Date, days: Int) -> Date {
		var dateComponents = DateComponents()
		dateComponents.day = days
		let calendar = Calendar.current
		guard let resultDate = calendar.date(byAdding: dateComponents, to: date) else {
			return date
		}
		return resultDate
	}
	
	func increment() {
		datePicker.setValue(offsetDate(datePicker.value, days: 1), animated: true)
		updateSummary()
	}

	func decrement() {
		datePicker.setValue(offsetDate(datePicker.value, days: -1), animated: true)
		updateSummary()
	}
}
```


### Advanced - Validation

![Change password form](https://github.com/neoneye/SwiftyFORM/raw/master/Documentation/change_password_form.gif "Change password form")

```swift
class ChangePasswordViewController: FormViewController {
	override func populate(_ builder: FormBuilder) {
		builder.navigationTitle = "Password"
		builder += SectionHeaderTitleFormItem().title("Your Old Password")
		builder += passwordOld
		builder += SectionHeaderTitleFormItem().title("Your New Password")
		builder += passwordNew
		builder += passwordNewRepeated
		builder.alignLeft([passwordOld, passwordNew, passwordNewRepeated])
	}
	
	lazy var passwordOld: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("Old password").password().placeholder("required")
		instance.keyboardType = .numberPad
		instance.autocorrectionType = .no
		instance.validate(CharacterSetSpecification.decimalDigitCharacterSet(), message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()
	
	lazy var passwordNew: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("New password").password().placeholder("required")
		instance.keyboardType = .numberPad
		instance.autocorrectionType = .no
		instance.validate(CharacterSetSpecification.decimalDigitCharacterSet(), message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()
	
	lazy var passwordNewRepeated: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("Repeat password").password().placeholder("required")
		instance.keyboardType = .numberPad
		instance.autocorrectionType = .no
		instance.validate(CharacterSetSpecification.decimalDigitCharacterSet(), message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()
}
```


# INSTALLATION

## CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SwiftyFORM into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'SwiftyFORM'
```

Then, run the following command:

```bash
$ pod install
```

## Carthage

[Link to demo project that shows a minimal SwiftyFORM app using Carthage](https://github.com/neoneye/SwiftyFORM-Carthage-Example).

To integrate SwiftyFORM into your Xcode project using Carthage, specify it in your `Cartfile`:
```
github "neoneye/SwiftyFORM" ~> 1.4
```

Then, run the following command:
```bash
$ carthage update
```

Finally, add `SwiftyFORM.framework` (will be built by Carthage under `Carthage/Build/iOS/`) to your project's _Linked Frameworks and Libraries_ in the _General_ tab, and add a new _Run Script_ Build Phase:
- Set `/bin/bash` as the shell
- write `/usr/local/bin/carthage copy-frameworks` in the script body
- add `$(SRCROOT)/Carthage/Build/iOS/SwiftyFORM.framework` to the input files 


# 📄 CHANGE LOG

### See [changelog.md](https://github.com/neoneye/SwiftyFORM/blob/master/changelog.md) 👀


# Help, feedback or suggestions?

- [Open an issue](https://github.com/neoneye/SwiftyFORM/issues/new) if you need help, if you found a bug, or if you want to discuss a feature request.
- [Open a PR](https://github.com/neoneye/SwiftyFORM/pull/new/master) if you want to make some change to SwiftyFORM.
- Contact [@neoneye on Twitter](https://twitter.com/neoneye) for discussions, news & announcements about SwiftyFORM.
