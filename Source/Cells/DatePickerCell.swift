// MIT license. Copyright (c) 2014 SwiftyFORM. All rights reserved.
import UIKit

public struct DatePickerCellModel {
	var title: String = ""
	var toolbarMode: ToolbarMode = .Simple
	var datePickerMode: UIDatePickerMode = .DateAndTime
	var locale: NSLocale? = nil // default is [NSLocale currentLocale]. setting nil returns to default
	var minimumDate: NSDate? = nil // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
	var maximumDate: NSDate? = nil // default is nil
	var expandCollapseWhenSelectingRow = true
	
	var valueDidChange: NSDate -> Void = { (date: NSDate) in
		SwiftyFormLog("date \(date)")
	}
}

public class DatePickerCell: UITableViewCell, SelectRowDelegate {
	weak var expandedCell: DatePickerCellExpanded?
	public let model: DatePickerCellModel

	public init(model: DatePickerCellModel) {
		/*
		Known problem: UIDatePickerModeCountDownTimer is buggy and therefore not supported
		
		UIDatePicker has a bug in it when used in UIDatePickerModeCountDownTimer mode. The picker does not fire the target-action
		associated with the UIControlEventValueChanged event the first time the user changes the value by scrolling the wheels.
		It works fine for subsequent changes.
		http://stackoverflow.com/questions/20181980/uidatepicker-bug-uicontroleventvaluechanged-after-hitting-minimum-internal
		http://stackoverflow.com/questions/19251803/objective-c-uidatepicker-uicontroleventvaluechanged-only-fired-on-second-select
		
		Possible work around: Continuously poll for changes.
		*/
		assert(model.datePickerMode != .CountDownTimer, "CountDownTimer is not supported")

		self.model = model
		super.init(style: .Value1, reuseIdentifier: nil)
		selectionStyle = .Default
		textLabel?.text = model.title
		
		updateValue()
		
		assignDefaultColors()
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	public func assignDefaultColors() {
		textLabel?.textColor = UIColor.blackColor()
		detailTextLabel?.textColor = UIColor.grayColor()
	}
	
	public func assignTintColors() {
		let color = self.tintColor
		SwiftyFormLog("assigning tint color: \(color)")
		textLabel?.textColor = color
		detailTextLabel?.textColor = color
	}
	
	public func resolveLocale() -> NSLocale {
		return model.locale ?? NSLocale.currentLocale()
	}
	
//	public lazy var datePicker: UIDatePicker = {
//		let instance = UIDatePicker()
//		instance.datePickerMode = self.model.datePickerMode
//		instance.minimumDate = self.model.minimumDate
//		instance.maximumDate = self.model.maximumDate
//		instance.addTarget(self, action: #selector(DatePickerCell.valueChanged), forControlEvents: .ValueChanged)
//		instance.locale = self.resolveLocale()
//		return instance
//		}()
	

//	public lazy var toolbar: SimpleToolbar = {
//		let instance = SimpleToolbar()
//		weak var weakSelf = self
//		instance.jumpToPrevious = {
//			if let cell = weakSelf {
//				cell.gotoPrevious()
//			}
//		}
//		instance.jumpToNext = {
//			if let cell = weakSelf {
//				cell.gotoNext()
//			}
//		}
//		instance.dismissKeyboard = {
//			if let cell = weakSelf {
//				cell.dismissKeyboard()
//			}
//		}
//		return instance
//		}()
//	
//	public func updateToolbarButtons() {
//		if model.toolbarMode == .Simple {
//			toolbar.updateButtonConfiguration(self)
//		}
//	}
//	
//	public func gotoPrevious() {
//		SwiftyFormLog("make previous cell first responder")
//		form_makePreviousCellFirstResponder()
//	}
//	
//	public func gotoNext() {
//		SwiftyFormLog("make next cell first responder")
//		form_makeNextCellFirstResponder()
//	}
	
//	public func dismissKeyboard() {
//		SwiftyFormLog("dismiss keyboard")
//		resignFirstResponder()
//	}
	
//	public override var inputView: UIView? {
//		return datePicker
//	}
//	
//	public override var inputAccessoryView: UIView? {
//		if model.toolbarMode == .Simple {
//			return toolbar
//		}
//		return nil
//	}

	public func valueChanged() {
//		let date = datePicker.date
//		model.valueDidChange(date)
//
//		updateValue()
	}
	
	public func obtainDateStyle(datePickerMode: UIDatePickerMode) -> NSDateFormatterStyle {
		switch datePickerMode {
		case .Time:
			return .NoStyle
		case .Date:
			return .LongStyle
		case .DateAndTime:
			return .ShortStyle
		case .CountDownTimer:
			return .NoStyle
		}
	}
	
	public func obtainTimeStyle(datePickerMode: UIDatePickerMode) -> NSDateFormatterStyle {
		switch datePickerMode {
		case .Time:
			return .ShortStyle
		case .Date:
			return .NoStyle
		case .DateAndTime:
			return .ShortStyle
		case .CountDownTimer:
			return .ShortStyle
		}
	}
	
	public func humanReadableValue() -> String {
		return "TODO"
//		if model.datePickerMode == .CountDownTimer {
//			let t = datePicker.countDownDuration
//			let date = NSDate(timeIntervalSinceReferenceDate: t)
//			let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
//			calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
//			let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: date)
//			let hour = components.hour
//			let minute = components.minute
//			return String(format: "%02d:%02d", hour, minute)
//		}
//		if true {
//			let date = datePicker.date
//			//SwiftyFormLog("date: \(date)")
//			let dateFormatter = NSDateFormatter()
//			dateFormatter.locale = self.resolveLocale()
//			dateFormatter.dateStyle = obtainDateStyle(model.datePickerMode)
//			dateFormatter.timeStyle = obtainTimeStyle(model.datePickerMode)
//			return dateFormatter.stringFromDate(date)
//		}
	}

	public func updateValue() {
		detailTextLabel?.text = humanReadableValue()
	}
	
	public func setDateWithoutSync(date: NSDate?, animated: Bool) {
		SwiftyFormLog("set date \(date), animated \(animated)")
//		datePicker.setDate(date ?? NSDate(), animated: animated)
		updateValue()
	}

/*	public func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView) {
		// Hide the datepicker wheel, if it's already visible
		// Otherwise show the datepicker
		
		let alreadyFirstResponder = (self.form_firstResponder() != nil)
		if alreadyFirstResponder {
			tableView.form_firstResponder()?.resignFirstResponder()
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
			return
		}
		
		//SwiftyFormLog("will invoke")
		// hide keyboard when the user taps this kind of row
		tableView.form_firstResponder()?.resignFirstResponder()
		self.becomeFirstResponder()
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		//SwiftyFormLog("did invoke")
	}*/
	
	// MARK: UIResponder
	
	/*public override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	public override func becomeFirstResponder() -> Bool {
		let result = super.becomeFirstResponder()
		updateToolbarButtons()
		assignTintColors()
		return result
	}
	
	public override func resignFirstResponder() -> Bool {
		super.resignFirstResponder()
		assignDefaultColors()
		return true
	}*/

	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
		return 60
	}
	
	public func form_didSelectRow(indexPath: NSIndexPath, tableView: UITableView) {
		guard let tableView = tableView as? FormTableView else {
			return
		}
		guard let expandedCell = expandedCell else {
			return
		}
		if model.expandCollapseWhenSelectingRow == false {
			return
		}
		tableView.expandCollapse(expandedCell: expandedCell, indexPath: indexPath)
	}
	
}

public class DatePickerCellExpanded: UITableViewCell, CellHeightProvider {
	weak var collapsedCell: DatePickerCell?
	
	public func form_cellHeight(indexPath: NSIndexPath, tableView: UITableView) -> CGFloat {
//		return PrecisionSlider_InnerModel.height
		return 159 // TODO:
	}
	
	func sliderDidChange(changeModel: PrecisionSlider.SliderDidChangeModel) {
//		collapsedCell?.sliderDidChange(changeModel)
	}
	
	
	
	lazy var datePicker: UIDatePicker = {
		let instance = UIDatePicker()
//		instance.valueDidChange = nil
		return instance
	}()
	
	public init() {
		super.init(style: .Default, reuseIdentifier: nil)
		addSubview(datePicker)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		datePicker.frame = bounds
		
//		let tinyDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Float(NSEC_PER_SEC)))
//		dispatch_after(tinyDelay, dispatch_get_main_queue()) {
//			self.assignInitialValue()
//		}
	}
	
//	func assignInitialValue() {
//		if slider.valueDidChange != nil {
//			return
//		}
//		guard let model = collapsedCell?.model else {
//			return
//		}
//		
//		slider.zoomUIHidden = !model.zoomUI
//		
//		let sliderViewModel = model.sliderViewModel(sliderWidth: slider.bounds.width)
//		slider.model = sliderViewModel
//		slider.layout.model = sliderViewModel
//		slider.reloadSlider()
//		slider.reloadZoomLabel()
//		
//		let decimalScale: Double = pow(Double(10), Double(model.decimalPlaces))
//		let scaledValue = Double(model.value) / decimalScale
//		
//		/*
//		First we scroll to the right offset
//		Next establish two way binding
//		*/
//		slider.value = scaledValue
//		
//		slider.valueDidChange = { [weak self] (changeModel: PrecisionSlider.SliderDidChangeModel) in
//			self?.sliderDidChange(changeModel)
//		}
//	}
	
//	func setValueWithoutSync(value: Int) {
//		guard let model = collapsedCell?.model else {
//			return
//		}
//		SwiftyFormLog("set value \(value)")
//		
//		let decimalScale: Double = pow(Double(10), Double(model.decimalPlaces))
//		let scaledValue = Double(value) / decimalScale
//		slider.value = scaledValue
//	}
}
