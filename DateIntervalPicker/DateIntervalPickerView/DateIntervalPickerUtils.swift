//
//  DateIntervalPickerUtils.swift
//  DateIntervalPicker
//
//  Created by Ismail Bozkurt on 10/04/2016.
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

class DateIntervalPickerUtils {

    static func numberOfDays(fromDate: NSDate, toDate: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDateTime: NSDate?, toDateTime: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDateTime, interval: nil, forDate: fromDate)
        calendar.rangeOfUnit(.Day, startDate: &toDateTime, interval: nil, forDate: toDate)
        
        let difference = calendar.components(.Day, fromDate: fromDateTime!, toDate: toDateTime!, options: [])
        return difference.day
    }
    
    static func beginningOf(date: NSDate, nextDay:Int = 0) -> NSDate {
        return self.updateDate(date, nextDay: nextDay, hour: 0, minute: 0, second: 0)
    }
    
    static func endOf(date: NSDate, nextDay:Int = 0) -> NSDate {
        return self.updateDate(date, nextDay: nextDay, hour: 23, minute: 59, second: 59)
    }

    private static func updateDate(date: NSDate, nextDay: Int, hour: Int, minute: Int, second: Int) -> NSDate{
        if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
            let comp = calendar.components(dateUnits, fromDate:date)
            
            comp.day += nextDay
            comp.hour = hour
            comp.minute = minute
            comp.second = second
            if let newDate = calendar.dateFromComponents(comp) {
                return newDate
            }
        }
        
        return date
    }
}
