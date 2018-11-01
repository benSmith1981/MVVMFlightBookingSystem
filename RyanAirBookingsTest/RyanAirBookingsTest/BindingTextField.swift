//
//  BindingTextBox.swift
//  MVVMBinding
//
//  Created by Mohammad Azam on 12/4/17.
//  Copyright © 2017 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit

class BindingTextField : UITextField, UITextFieldDelegate {
    
    var textChanged :(String) -> () = { _ in }
    
    
    func bind(callback :@escaping (String) -> ()) {
       
        self.textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: [.allEditingEvents])

    }
    
    @objc func textFieldDidChange(_ textField :UITextField) {
        self.textChanged(textField.text!)
    }

}

extension BindingTextField {
    //Subctract button
    func subtract() {
        self.becomeFirstResponder()
        var numberToReturn = "0"
        numberToReturn = checkTextNumberNotLessThanZero(numberToReturn)
        numberToReturn = checkTextAdultNotLessThanOne(numberToReturn)
        self.text = numberToReturn
    }
    
    func checkTextNumberNotLessThanZero(_ numberToReturn: String) -> String{
        if let text = self.text,
            let number = Int(text) {
            return number > 0 ? "\(number - 1)" : "\(number)"
        } else {
            return numberToReturn
        }
    }
    
    func checkTextAdultNotLessThanOne(_ numberToReturn: String)  -> String {
        if self.tag == buttonTags.adults.rawValue && numberToReturn == "0" {
            return "1"
        } else {
            return numberToReturn
        }
    }
    
//Add button
    func add() {
        self.becomeFirstResponder()
        var numberToReturn = "0"
        numberToReturn = checkTextNumberNotGreaterThanSix(numberToReturn)
        numberToReturn = checkTextAdultNotZero(numberToReturn)
        self.text = numberToReturn
    }
    
    func checkTextNumberNotGreaterThanSix(_ numberToReturn: String) -> String{
        if let text = self.text,
            let number = Int(text) {
            return number < 6 ? "\(number + 1)" : "\(number)"
        }
        return numberToReturn
    }
    
    func checkTextAdultNotZero(_ numberToReturn: String) -> String{
        if self.tag == buttonTags.adults.rawValue && numberToReturn == "0" {
            return "1"
        }
        return numberToReturn
    }
}
