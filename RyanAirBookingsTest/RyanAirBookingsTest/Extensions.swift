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

extension String {
    
    func nicelyFormattedDateString() -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "2018-04-10T04:00:00.000Z"
        //Parse into NSDate
        let unitFlags = Set<Calendar.Component>([.hour, .minute, .day, .month, .year,])

        if let dateFromString : NSDate = dateFormatter.date(from: self) as NSDate?
            {
            let components = NSCalendar.current.dateComponents(unitFlags, from: dateFromString as Date)
            
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
            
            
            //Return Parsed Date
            if let hour = components.hour, let minute = components.minute, let day = components.day, let monthComp = components.month, let year = components.year {
                return "\(hour):\(minute), \(day) \(month[monthComp]) \(year))"
            } else {
                return self
            }
        }
        return self

    }
}
