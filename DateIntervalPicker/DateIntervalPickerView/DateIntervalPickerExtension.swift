//
//  DateIntervalPickerExtension.swift
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

import Foundation

private let dateUnits:NSCalendarUnit =
    [.Year, .Month, .Day, .Hour, .Minute, .Second, .WeekOfYear, .Weekday, .WeekdayOrdinal]


extension NSDate {
    
    func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
    
    func beginningOfDay(nextDay:Int = 0) -> NSDate {
        
        var date = self
        
        if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
            let comp = calendar.components(dateUnits, fromDate:date)
            
            comp.day += nextDay
            comp.hour = 0
            comp.minute = 0
            comp.second = 0
            if let endDate = calendar.dateFromComponents(comp) {
                date = endDate
            }
        }
        
        return date
    }

    func endOfDay(nextDay:Int = 0) -> NSDate {
        
        var date = self
        
        if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
            let comp = calendar.components(dateUnits, fromDate:date)
            
            comp.day += nextDay
            comp.hour = 23
            comp.minute = 59
            comp.second = 59
            if let endDate = calendar.dateFromComponents(comp) {
                date = endDate
            }
        }
        
        return date
    }

}