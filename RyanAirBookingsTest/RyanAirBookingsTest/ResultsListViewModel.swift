//
//  ResultsListViewModel.swift
//  RyanAirBooker
//
//  Created by Ben Smith on 30/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation



//Represenets everything happening in the Results screen
class ResultsListViewModels {
    var resultViewModels: [ResultViewModel] = [ResultViewModel]()
    private var tripviewModel: TripViewModel
    
    init(tripviewModel: TripViewModel) {
        self.tripviewModel = tripviewModel

    }
    
    func search(tripviewModel: TripViewModel, onCompletion: @escaping (ResultsListViewModels, String) -> Void) {
        //search and get results
        DataAccess.shared.getSearchResults(tripviewModel: self.tripviewModel, success: { (trips, data) in
            trips.forEach({ trip in
                self.getDate(from: trip)
            })
            DispatchQueue.main.async {
                onCompletion(self, "Succcess")
            }
        }) { (message) in
            print(message)
            DispatchQueue.main.async {
                onCompletion(self, message)
            }

        } //Returns and array of RESULTS objects
        
        //Then put results int view models ready for the view
        //keep view model as plain and dumb as possible...
    }
    
    func getDate(from trip: Trips) {
        trip.dates?.forEach({ (date) in
            if let dateOut = date.dateOut {
                getFlightNumberAndRegularFare(from: date, with: dateOut)
            }
        })
    }
    
    func getFlightNumberAndRegularFare(from dates: Dates, with dateOut: String){
        dates.flights?.forEach({ (flight) in
            let flightNumber = flight.flightNumber
            let fare = flight.regularFare?.fares[0].publishedFare
            //create model
            let resultViewModel = ResultViewModel.init(date: dateOut ,
                                                       flightNumber: flightNumber ?? "",
                                                       regularFare: fare ?? 0.0)
            self.resultViewModels.append(resultViewModel)
        })
    }
}


//this is the data that we want displayed on the screen
class ResultViewModel {
    var date: String!
    var flightNumber: String!
    var regularFare: Double!
    
    init(date: String, flightNumber: String, regularFare: Double) {
        self.date = date
        self.flightNumber = flightNumber
        self.regularFare = regularFare
    }
}
