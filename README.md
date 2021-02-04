<h3 align="center">
<a href="https://github.com/neoneye/SwiftyFORM">
<img src="Documentation/swiftyform_logo.png" alt="SwiftyFORM by Simon Strandgaard"/>
<br />
SwiftyFORM
</a>
</h3>

---

<p align="center">
    <a href="https://travis-ci.org/neoneye/SwiftyFORM">
        <img src="https://travis-ci.org/neoneye/SwiftyFORM.svg?branch=master" alt="Build Status" />
    </a>
    <a href="http://cocoapods.org/pods/SwiftyFORM">
        <img src="https://img.shields.io/cocoapods/v/SwiftyFORM.svg?style=flat" alt="Version" />
    </a>
    <a href="http://cocoapods.org/pods/SwiftyFORM">
        <img src="https://img.shields.io/cocoapods/p/SwiftyFORM.svg?style=flat" alt="Platform" />
    </a>
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat" alt="Carthage" />
    </a>
    <a href="http://cocoapods.org/pods/SwiftyFORM">
        <img src="https://img.shields.io/cocoapods/l/SwiftyFORM.svg?style=flat" alt="MIT License" />
    </a>
</p>

<p align="center">
    <b>SwiftyFORM is a lightweight iOS framework for creating forms</b>
</p>

<p align="center">
    <img src="https://github.com/neoneye/SwiftyFORM/raw/master/Documentation/light_and_dark1.png" alt="Dark Mode supported" /> 
</p>


Because form code is hard to write, hard to read, hard to reason about. Has a slow turn around time. Is painful to maintain.

[SwiftyFORM demo on YouTube](https://youtu.be/PKbVJ91uQdA)


<a href="mailto:neoneye@gmail.com?subject=Hire Simon Strandgaard">
<img src="Documentation/hire_simon_strandgaard@2x.png" width="211" height="34"></a>


## Requirements

- iOS 12+
- Xcode 12+
- Swift 5.1+


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

## Swift Package Manager

With Swift Package Manager support in the latest Xcode, installation has never been easier.

Open your Xcode project -> `File` -> `Swift Packages` -> `Add Package Dependency...`

Search for `SwiftyFORM` and specify the version you want. The latest tagged release is usually a good idea.

## CocoaPods

To integrate SwiftyFORM into your Xcode project using CocoaPods, specify the following in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
swift_version = '5.0'
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
    pod 'SwiftyFORM', '~> 1.8'
end
```

Then, run the following command:

```bash
$ pod install
```

## Carthage

[Link to demo project that shows a minimal SwiftyFORM app using Carthage](https://github.com/neoneye/SwiftyFORM-Carthage-Example).

To integrate SwiftyFORM into your Xcode project using Carthage, specify it in your `Cartfile`:
```
github "neoneye/SwiftyFORM" ~> 1.8
```

Then, run the following command:
```bash
$ carthage update
```

Finally, add `SwiftyFORM.framework` (will be built by Carthage under `Carthage/Build/iOS/`) to your project's _Linked Frameworks and Libraries_ in the _General_ tab, and add a new _Run Script_ Build Phase:
- Set `/bin/bash` as the shell
- write `/usr/local/bin/carthage copy-frameworks` in the script body
- add `$(SRCROOT)/Carthage/Build/iOS/SwiftyFORM.framework` to the input files 

## Manual

1. Open up Terminal application and cd into your iOS project directory

2. ONLY IF your project is not already initialized as a git repository, run
```
$ git init
```

3. Add `SwiftyFORM` as a submodule by running
```
$ git submodule add https://github.com/neoneye/SwiftyFORM.git
```

4. In the Project Navigator, select your application project and go to "Targets" -> "General"

5. Open the project folder and drag the `SwiftyFORM.xcodeproj` file into the "Frameworks, Libraries, and Embedded Content" tab of your application. 

6. Click the `+` button under the "Frameworks, Libraries, and Embedded Content" section and `Add` the `SwiftyFORM.framework`

# Communication

- If you want to contribute, submit a pull request.
- If you found a bug, have suggestions or need help, please, open an issue.
- If you need help, write me: neoneye@gmail.com

