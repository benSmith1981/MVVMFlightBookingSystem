//
//  TripViewModel.swift
//  RyanAirBooker
//
//  Created by Ben Smith on 30/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation

//view model to view live binding , that binds the values in our model to the text field values
class Dynamic<T> {
    
    typealias Listener = (T) -> Void
    var listener :Listener?
    
    func bind(listener :Listener?) {
        self.listener = listener
        listener?(value!)
    }
    
    var value :T? {
        didSet {
            listener?(value!)
        }
    }
    
    init(_ v:T) {
        value = v
    }
    
}

struct ValidationError {
    var validationName: String
    var message: String
}
protocol ViewModel {
    var validationError: [ValidationError] { get set}
    var isValid: Bool { mutating get}
}

//Represenets everything happening in the triptable screen
class TripViewModel:ViewModel {
    var validationError: [ValidationError] = [ValidationError]()
    var isValid: Bool {
        get {
            self.validationError = [ValidationError]()
            self.validate()
            return validationError.count == 0 ? true : false
        }
    }

    var origin: Dynamic<String>!
    var destination: Dynamic<String>!
    var departure: Dynamic<String>!
    var adults: Dynamic<String>!
    var teen: Dynamic<String>!
    var children: Dynamic<String>!
    
    init(origin: String, destination: String, departure: String, adults: String, teen: String, children: String) {
        self.origin = Dynamic<String>(origin)
        self.destination = Dynamic<String>(destination)
        self.departure = Dynamic<String>(departure)
        self.adults = Dynamic<String>(adults)
        self.teen = Dynamic<String>(teen)
        self.children = Dynamic<String>(children)
    }

}

extension TripViewModel {
    private func validate() {
        if let empty = origin.value?.isEmpty, empty == true {
            self.validationError.append(ValidationError.init(validationName: "Origin", message: "Provide Start Destination"))
        }
        
        if let empty = destination.value?.isEmpty, empty == true {
            self.validationError.append(ValidationError.init(validationName: "destination", message: "Provide End Destination"))
        }
        
        if let empty = departure.value?.isEmpty, empty == true {
            self.validationError.append(ValidationError.init(validationName: "departure", message: "Provide Departure Date"))
        }
        if let teenEmpty = teen.value?.isEmpty,
            let adultEmpty = adults.value?.isEmpty,
            let childrenEmpty = children.value?.isEmpty,
            adultEmpty == true && childrenEmpty == true && teenEmpty == true{
            self.validationError.append(ValidationError.init(validationName: "No Passengers", message: "You must provide atleast one passenger"))
        }
    
    }
}
