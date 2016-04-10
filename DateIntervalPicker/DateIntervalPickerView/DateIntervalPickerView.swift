//
//  DateIntervalPickerView.swift
//  DateIntervalPicker
//
//  Created by Ismail Bozkurt on 09/04/2016.
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Ismail Bozkurt
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import GLCalendarView
import IBViewBorders

protocol DateIntervalPickerViewDelegate : class {
    func dateIntervalPickerView(dateIntervalPickerView: DateIntervalPickerView, didUpdateStartDate startDate: NSDate)
    func dateIntervalPickerView(dateIntervalPickerView: DateIntervalPickerView, didUpdateEndDate endDate: NSDate)
}

class DateIntervalPickerView: UIView, GLCalendarViewDelegate {
    
    // MARK: Private Properties
    private var calendarView: GLCalendarView!
    private var currentDateRange: GLCalendarDateRange?
    private var lastSize: CGSize! = CGSizeZero
    
    // MARK: Public Properties
    var delegate: DateIntervalPickerViewDelegate?
    
    /// Default is today
    var startDate : NSDate! = DateIntervalPickerView.beginningOfDate(NSDate()) {
        didSet {
            self.currentDateRange?.beginDate = self.startDate
            
            if let _ = self.calendarView {
                self.calendarView.reload()
            }
        }
    }
    
    /// Default one week later
    var endDate : NSDate! = GLDateUtils.dateByAddingDays(7, toDate:DateIntervalPickerView.endOfDate(NSDate())) {
        didSet {
            self.currentDateRange?.endDate = self.endDate
            
            if let _ = self.calendarView {
                self.calendarView.reload()
            }
        }
    }
    
    // MARK: Custom setters
    
    private func setStartDate(startDate: NSDate) {
        self.startDate = startDate
        self.delegate?.dateIntervalPickerView(self, didUpdateStartDate: startDate)
    }
    
    private func setEndDate(endDate: NSDate) {
        self.endDate = endDate
        self.delegate?.dateIntervalPickerView(self, didUpdateEndDate: endDate)
    }
    
    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        fatalError("init(frame:) has not been implemented, try to initialize through a nib instead.")
        self.setup()
        self.reload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        self.reload()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.focusToCurrentRange(false)

    }    
    
    // MARK: Setup
    
    private func setup() {
        self.lastSize = self.bounds.size
        
        self.setupCalendarView()
        self.reload()
        self.focusToCurrentRange(false)
    }
    
    private func setupCalendarView() {
        self.calendarView = GLCalendarView()
        self.addSubview(self.calendarView)
        self.setupCalendarViewConstraints()
        
        self.calendarView.delegate = self
        self.calendarView.showMagnifier = true
        self.calendarView.calendar.locale = NSLocale(localeIdentifier: "tr-TR")
        
        self.calendarView.firstDate = GLDateUtils.dateByAddingDays(-365, toDate:DateIntervalPickerView.beginningOfDate(NSDate()))
        self.calendarView.lastDate = GLDateUtils.dateByAddingDays(365, toDate:DateIntervalPickerView.endOfDate(NSDate()))
        
        let range : GLCalendarDateRange = createRangeWithStartDate(self.startDate, endDate: self.endDate)
        self.startWorkingOnRange(range)
    }
    
    private func setupCalendarViewConstraints() {
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.ib_addLeadConstraintToSuperViewWithMargin(0.0)
        self.calendarView.ib_addTopConstraintToSuperViewWithMargin(0.0)
        self.calendarView.ib_addTrailingConstraintToSuperViewWithMargin(0.0)
        self.calendarView.ib_addBottomConstraintToSuperViewWithMargin(0.0)
        self.calendarView.layoutIfNeeded()
    }
    
    private func reload() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.calendarView.reload()
        }
    }
    
    private func focusToCurrentRange(animated: Bool) {
        self.calendarView.scrollToDate(self.startDate, animated: animated)
    }
    
    // MARK: GLCalendarViewDelegate
    func calenderView(calendarView: GLCalendarView!, canAddRangeWithBeginDate beginDate: NSDate!) -> Bool {
        let rangeDayCount = self.currentRangeDayCount()
        if rangeDayCount == NSNotFound{
            return true
        }
        else if rangeDayCount > 0 {
            calendarView.removeRange(self.currentDateRange)
            calendarView.reload()
            return true
        }
        else {
            return false
        }
    }
    
    func calenderView(calendarView: GLCalendarView!, rangeToAddWithBeginDate beginDate: NSDate!) -> GLCalendarDateRange! {
        let range = self.createRangeWithStartDate(beginDate, endDate: beginDate)
        return range
    }
    
    func calenderView(calendarView: GLCalendarView!, beginToEditRange range: GLCalendarDateRange!) {
        print("beginToEditRange: \(range)")
    }
    
    func calenderView(calendarView: GLCalendarView!, finishEditRange range: GLCalendarDateRange!, continueEditing: Bool) {
        print("finishEditRange: \(range)")
    }
    
    func calenderView(calendarView: GLCalendarView!, canUpdateRange range: GLCalendarDateRange!, toBeginDate beginDate: NSDate!, endDate: NSDate!) -> Bool {
        return true
    }
    
    func calenderView(calendarView: GLCalendarView!, didUpdateRange range: GLCalendarDateRange!, toBeginDate beginDate: NSDate!, endDate: NSDate!) {
        self.updateRangeWithSelectedRange(range)
    }
    
    func calenderView(calendarView: GLCalendarView!, didSelectDate date: NSDate!) {
        let currentRangeDayCount = self.currentRangeDayCount()
        
        let newRangeClosure: dispatch_block_t = { [unowned self] in
            calendarView.removeRange(self.currentDateRange)
            let newRange = self.createRangeWithStartDate(date, endDate: date);
            self.startWorkingOnRange(newRange)
            self.updateRangeWithSelectedRange(newRange)
        }
        
        let updateCurrentRangeClosure: dispatch_block_t = { [unowned self] in
            if (self.beginningOfDate(date).compare((self.startDate)!) == NSComparisonResult.OrderedAscending) {
                self.setStartDate(self.beginningOfDate(date))
            }
            else if (self.endOfDate(date).compare((self.endDate)!) == NSComparisonResult.OrderedDescending) {
                self.setEndDate(self.endOfDate(date))
            }
            
            self.calendarView.updateRange(self.currentDateRange, withBeginDate: self.currentDateRange?.beginDate, endDate: self.currentDateRange?.endDate)
            self.calendarView.beginToEditRange(self.currentDateRange)
        }
        
        if currentRangeDayCount == NSNotFound || currentRangeDayCount > 0 {
            newRangeClosure()
        }
        else {
            updateCurrentRangeClosure()
        }
        
    }
    
    // MARK: Helpers
    
    private func updateRangeWithSelectedRange(range: GLCalendarDateRange) {
        self.setStartDate(range.beginDate)
        self.setEndDate(range.endDate)
    }
    
    private func startWorkingOnRange(range:GLCalendarDateRange) {
        //        dispatch_async(dispatch_get_main_queue()) { () -> Void in
        self.calendarView.ranges.removeAllObjects()
        self.calendarView.reload()
        
        self.calendarView.addRange(range)
        self.calendarView.beginToEditRange(range)
        
        self.currentDateRange = range
        //        }
    }
    
    private func createRangeWithStartDate(startDate: NSDate, endDate: NSDate) -> GLCalendarDateRange {
        let startDate = DateIntervalPickerView.beginningOfDate(startDate)
        let endDate = DateIntervalPickerView.endOfDate(endDate)
        
        let range: GLCalendarDateRange =
            GLCalendarDateRange(beginDate:DateIntervalPickerView.beginningOfDate(startDate)
                , endDate:DateIntervalPickerView.endOfDate(endDate))
        range.backgroundColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        range.editable = true
        
        return range
    }
    
    private static func beginningOfDate(date: NSDate) -> NSDate{
        return DateIntervalPickerUtils.beginningOf(date)
    }
    
    private static func endOfDate(date: NSDate) -> NSDate{
        return DateIntervalPickerUtils.endOf(date)
    }
    
    private func currentRangeDayCount() -> Int {
        var dayCount: Int = NSNotFound
        
        if let currentRange = self.calendarView.ranges.firstObject as? GLCalendarDateRange {
            dayCount = DateIntervalPickerUtils.numberOfDays(currentRange.beginDate, toDate: currentRange.endDate)
        }
        
        return dayCount
    }
}



