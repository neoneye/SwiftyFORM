[![License](https://img.shields.io/badge/license-MIT-gray.svg)](http://cocoadocs.org/docsets/SwiftyFORM)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](http://cocoadocs.org/docsets/SwiftyFORM)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# SwiftyFORM

SwiftyFORM is a form framework for iOS written in Swift.

![SwiftyFORM logo](https://github.com/neoneye/SwiftyFORM/raw/master/Documentation/swiftyform_logo.png)


## Features

- [x] 13 built in form items that can be used in a form
- [x] You can create your own custom form items
- [x] Align textfields across multiple rows
- [x] Form validation rule engine
- [x] Shows with red text where there are problems with validation


## Setup

- Xcode7.3.1 (7D1014)
- iOS 9

# INSTALLATION

## CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SwiftForms into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
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
github "neoneye/SwiftyFORM" ~> 0.9
```

Then, run the following command:
```bash
$ carthage update
```

Finally, add `SwiftyFORM.framework` (will be built by Carthage under `Carthage/Build/iOS/`) to your project's _Linked Frameworks and Libraries_ in the _General_ tab, and add a new _Run Script_ Build Phase:
- Set `/bin/bash` as the shell
- write `/usr/local/bin/carthage copy-frameworks` in the script body
- add `$(SRCROOT)/Carthage/Build/iOS/SwiftyFORM.framework` to the input files 


# USAGE

### Change password form

![Change password form](https://github.com/neoneye/SwiftyFORM/raw/master/Documentation/change_password_form.gif "Change password form")

```swift
import SwiftyFORM

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

# 📄 CHANGE LOG

### See [changelog.md](https://github.com/neoneye/SwiftyFORM/blob/master/changelog.md) 👀


# MIT LICENSE

SwiftyFORM is released under the MIT license. See LICENSE for details.
