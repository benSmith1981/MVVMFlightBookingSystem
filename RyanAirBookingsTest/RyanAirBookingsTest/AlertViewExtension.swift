//
//  AlertViewExtension.swift
//  RyanAirBookingsTest
//
//  Created by Ben Smith on 01/11/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation
import UIKit
protocol ShowsAlert {}

extension ShowsAlert where Self: UIViewController {
    func showAlert(title: String = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
