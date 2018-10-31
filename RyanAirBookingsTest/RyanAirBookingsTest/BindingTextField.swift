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
        self.addTarget(self, action: #selector(textFieldDidChange), for: [.editingChanged])

    }
    
    @objc func textFieldDidChange(_ textField :UITextField) {
        self.textChanged(textField.text!)
    }
    
    
}

extension BindingTextField {
    func subtract() {
        self.becomeFirstResponder()

        var numberToReturn = "1"
        if let text = self.text,
            let number = Int(text), number > 0 {
            numberToReturn = "\(number - 1)"
        }
        self.text = numberToReturn
    }
    
    func add() {
        self.becomeFirstResponder()
        var numberToReturn = "0"
        if let text = self.text,
            let number = Int(text) {
            numberToReturn = "\(number + 1)"
        }
        self.text = numberToReturn
    }
}
