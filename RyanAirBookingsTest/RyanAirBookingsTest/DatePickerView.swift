//
//  DatePickerView.swift
//  RyanAirBookingsTest
//
//  Created by Ben Smith on 31/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import UIKit

class DatePickerView: UIPickerView, UIPickerViewDelegate {
    var tripViewModel: TripViewModel!
    var textField: BindingTextField!
    var daySelected: Int = 0
    var monthSelected: String = ""
    var yearSelected: Int = 2017
    
    var day: [Int] = [Int](0...31)
    
    var month = [NSLocalizedString("Jan", comment: ""),
                 NSLocalizedString("Feb", comment: ""),
                 NSLocalizedString("Mar", comment: ""),
                 NSLocalizedString("Apr", comment: ""),
                 NSLocalizedString("May", comment: ""),
                 NSLocalizedString("Jun", comment: ""),
                 NSLocalizedString("Jul", comment: ""),
                 NSLocalizedString("Aug", comment: ""),
                 NSLocalizedString("Sep", comment: ""),
                 NSLocalizedString("Oct", comment: ""),
                 NSLocalizedString("Nov", comment: ""),
                 NSLocalizedString("Dec", comment: "")]
    
    var year = 1800...2050
    
    lazy var datePickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: .allEvents)
        picker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.delegate = self
    }
    
    func setupToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker(sender:)))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker(sender : UIBarButtonItem) {
//        updateCallback?(previousSelectedItems , indexPath!, 0)
        textField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("d")
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let cal = NSCalendar.current
        var comp = cal.dateComponents([ .era, .day , .month, .year], from: datePickerView.date)
        let dateString = "\(comp.day!) \(month[comp.month! - 1]) \(comp.year!)"
        self.tripViewModel.departure.value = dateString
        textField.text = dateString
        // getting day, month, year ect
//        textfieldValue.text = "\(comp.day!) \(month[comp.month! - 1]) \(comp.year!)"
        
    }

}
