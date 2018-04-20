//
//  DatePickerViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/14/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController
{
    var datePicker = UIDatePicker()

    override func loadView()
    {
        self.view = datePicker
        self.datePicker.datePickerMode = .date
        self.datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        self.datePicker.backgroundColor = .clear
    }
}
