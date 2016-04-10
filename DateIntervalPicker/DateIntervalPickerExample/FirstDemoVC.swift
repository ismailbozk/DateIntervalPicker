//
//  FirstDemoVC.swift
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

import UIKit

class FirstDemoVC: UIViewController, DateIntervalPickerViewDelegate {
    
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var dateIntervalPickerView: DateIntervalPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let oneYear: NSTimeInterval = (60 * 60 * 24 * 30 * 12 /* years*/)
        
        self.dateIntervalPickerView.delegate = self
        self.dateIntervalPickerView.startDate = NSDate()
        self.dateIntervalPickerView.endDate = NSDate()
        self.dateIntervalPickerView.boundingStartDate = NSDate(timeInterval: (oneYear * 0.5 /* years*/), sinceDate: NSDate())
        self.dateIntervalPickerView.boundingEndDate = NSDate(timeInterval: (oneYear * 1 /* years*/), sinceDate: NSDate())
        
        self.dateIntervalPickerView.startDate = NSDate(timeIntervalSinceNow: oneYear)
        
        self.dateIntervalPickerView.rangeBackgroundColor = UIColor.redColor()
        self.dateIntervalPickerView.reload()
        
        self.beginDateLabel.text = self.dateIntervalPickerView.startDate.description
        self.endDateLabel.text = self.dateIntervalPickerView.endDate.description
    }
    
    // MARK: DateIntervalPickerViewDelegate
    
    func dateIntervalPickerView(dateIntervalPickerView: DateIntervalPickerView, didUpdateStartDate startDate: NSDate) {
        self.beginDateLabel.text = startDate.description
    }
    
    func dateIntervalPickerView(dateIntervalPickerView: DateIntervalPickerView, didUpdateEndDate endDate: NSDate) {
        self.endDateLabel.text = endDate.description
    }
    
}
