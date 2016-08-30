<p align="center">
  <img src="https://github.com/neoneye/SwiftyFORM/raw/master/Documentation/swiftyform_logo.png" alt="SwiftyFORM by Simon Strandgaard"/>
</p>

[![License](https://img.shields.io/badge/license-MIT-gray.svg)](http://cocoadocs.org/docsets/SwiftyFORM)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](http://cocoadocs.org/docsets/SwiftyFORM)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


## Introduction

**SwiftyFORM** is an iOS framework for creating forms.

Because form code is hard to write, hard to read, hard to reason about. Has a slow turn around time. Is painful to maintain.

[SwiftyFORM demo on YouTube](https://youtu.be/PKbVJ91uQdA)

Development happens in the [`develop`](https://github.com/neoneye/SwiftyFORM/tree/develop) branch.


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
	override func populate(builder: FormBuilder) {
		builder += StaticTextFormItem().title("Hello").value("World")
	}
}
```

### Tutorial 1 - TextField

```swift
import SwiftyFORM
class MyViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder += TextFieldFormItem().title("Email").placeholder("Please specify").keyboardType(.EmailAddress)
	}
}
```

### Tutorial 2 - Open child view controller

```swift
import SwiftyFORM
class MyViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder += ViewControllerFormItem().title("Go to view controller").viewController(FirstViewController.self)
	}
}
```

### Advanced - date picker

![DatePicker with prev button and next button](https://github.com/neoneye/SwiftyFORM/raw/master/Documentation/datepicker_nextprev.jpg "DatePicker with prev button and next button")

```swift
class DatePickerBindingViewController: FormViewController {
	override func populate(builder: FormBuilder) {
		builder += datePicker
		builder += incrementButton
		builder += decrementButton
		builder += SectionFormItem()
		builder += summary
		updateSummary()
	}
	
	lazy var datePicker: DatePickerFormItem = {
		let instance = DatePickerFormItem()
		instance.title("Date")
		instance.datePickerMode = .Date
		instance.behavior = .ExpandedAlways
		instance.valueDidChangeBlock = { [weak self] _ in
			self?.updateSummary()
		}
		return instance
	}()
	
	lazy var incrementButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Next Day")
		instance.action = { [weak self] in
			self?.increment()
		}
		return instance
	}()
	
	lazy var decrementButton: ButtonFormItem = {
		let instance = ButtonFormItem()
		instance.title("Previous Day")
		instance.action = { [weak self] in
			self?.decrement()
		}
		return instance
	}()
	
	lazy var summary: StaticTextFormItem = {
		return StaticTextFormItem().title("NSDate").value("-")
	}()
	
	func updateSummary() {
		summary.value = "\(datePicker.value)"
	}
	
	func offsetDate(date: NSDate, days: Int) -> NSDate {
		let dateComponents = NSDateComponents()
		dateComponents.day = days
		let calendar = NSCalendar.currentCalendar()
		guard let resultDate = calendar.dateByAddingComponents(dateComponents, toDate: date, options: NSCalendarOptions(rawValue: 0)) else {
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
	override func populate(builder: FormBuilder) {
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
		instance.keyboardType = .NumberPad
		instance.autocorrectionType = .No
		instance.validate(CharacterSetSpecification.decimalDigitCharacterSet(), message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()
	
	lazy var passwordNew: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("New password").password().placeholder("required")
		instance.keyboardType = .NumberPad
		instance.autocorrectionType = .No
		instance.validate(CharacterSetSpecification.decimalDigitCharacterSet(), message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()
	
	lazy var passwordNewRepeated: TextFieldFormItem = {
		let instance = TextFieldFormItem()
		instance.title("Repeat password").password().placeholder("required")
		instance.keyboardType = .NumberPad
		instance.autocorrectionType = .No
		instance.validate(CharacterSetSpecification.decimalDigitCharacterSet(), message: "Must be digits")
		instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
		instance.validate(CountSpecification.max(6), message: "Length must be maximum 6 digits")
		return instance
		}()
}
```


# INSTALLATION

## Setup

- Xcode7.3.1 (7D1014)
- iOS 9

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
github "neoneye/SwiftyFORM" ~> 0.11
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
