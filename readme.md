[![License](https://img.shields.io/badge/license-MIT-gray.svg)](http://cocoadocs.org/docsets/SwiftForms)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](http://cocoadocs.org/docsets/SwiftForms)

# SwiftyFORM

SwiftyFORM is a form framework for iOS written in Swift.


## Features

- [x] 13 built in form items that can be used in a form
- [x] You can create your own custom form items
- [x] Align textfields across multiple rows
- [x] Form validation rule engine
- [x] Shows with red text where there are problems with validation


## Setup

- Xcode7.3.1 (7D1014)
- iOS 9

## Installation
### CocoaPods

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

## Usage

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


## License

SwiftyFORM is released under the MIT license. See LICENSE for details.
