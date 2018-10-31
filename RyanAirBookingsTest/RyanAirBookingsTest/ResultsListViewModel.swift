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
    private var dataAccess: DataAccess
    private var tripviewModel: TripViewModel
    
    init(dataAccess: DataAccess, tripviewModel: TripViewModel) {
        self.dataAccess = dataAccess
        self.tripviewModel = tripviewModel
    }
    
    private func search(tripviewModel: TripViewModel){
        //search and get results
        let results = dataAccess.getSearchResults(tripviewModel: self.tripviewModel) //Returns and array of RESULTS objects
        
        //Then put results int view models ready for the view
        //keep view model as plain and dumb as possible...
        self.resultViewModels = results.compactMap({ result in
            return ResultViewModel.init(date: result.date!,
                                        flightNumber: result.flightNumber!,
                                        regularFare: result.regularFare!)
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
