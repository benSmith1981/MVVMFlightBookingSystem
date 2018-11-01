//
//  StationViewListModel.swift
//  RyanAirBookingsTest
//
//  Created by Ben Smith on 31/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation

class StationListViewModel {
    var stationListViewModels: [StationListModel] = [StationListModel]()
    
    func getAllStations(onCompletion: @escaping (StationListViewModel, Bool) -> Void) {
        //search and get results
        DataAccess.shared.getStations(success: { (results, data) in
            
            self.stationListViewModels = results.compactMap({ result in
                return StationListModel.init(code: result.code!,
                                            countryCode: result.countryCode!,
                                            countryName: result.countryName!)
            })
            DispatchQueue.main.async {
                onCompletion(self, true)
            }
            
        }) { (message) in
            print(message)
            DispatchQueue.main.async {
                onCompletion(self, false)
            }
        } //Returns and array of RESULTS objects
        
        //Then put results int view models ready for the view
        //keep view model as plain and dumb as possible...
    }
}

class StationListModel {
    var code: String?
    var countryCode: String?
    var countryName: String?
    
    init(code: String, countryCode: String, countryName: String) {
        self.code = code
        self.countryCode = countryCode
        self.countryName = countryName
    }
}
