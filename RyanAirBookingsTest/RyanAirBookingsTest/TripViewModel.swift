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

//Represenets everything happening in the triptable screen
class TripViewModel {
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
