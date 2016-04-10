//
//  SecondDemoVC.swift
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

class SecondDemoVC: UIViewController, DateIntervalPickerViewDelegate {
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    var dateIntervalPickerView: DateIntervalPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateIntervalPickerView = DateIntervalPickerView()
        self.view.addSubview(self.dateIntervalPickerView)
        self.dateIntervalPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.dateIntervalPickerView.ib_addTopConstraintToSuperViewWithMargin(40.0)
        self.dateIntervalPickerView.ib_addLeadConstraintToSuperViewWithMargin(0.0)
        self.dateIntervalPickerView.ib_addTrailingConstraintToSuperViewWithMargin(0.0)
        self.dateIntervalPickerView.ib_addHeightConstraint(400.0)
        self.dateIntervalPickerView.layoutIfNeeded()
        
        self.dateIntervalPickerView.delegate = self
        self.dateIntervalPickerView.startDate = NSDate()
        self.dateIntervalPickerView.endDate = NSDate(timeInterval: -(60 * 60 * 24 * 2), sinceDate: NSDate())
        
        self.dateIntervalPickerView.rangeBackgroundColor = UIColor.purpleColor()
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
