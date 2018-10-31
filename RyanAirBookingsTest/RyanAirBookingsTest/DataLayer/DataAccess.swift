//
//  DataAccess.swift
//  RyanAirBooker
//
//  Created by Ben Smith on 30/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation
import Alamofire

class APIResponse {
    var json:Data;
    var errorMessage:String?;
    init(json:Data) {
        self.json = json
    }
}

class DataAccess {
    static let shared = DataAccess()
    

    private init() {
    }
    
    func getSearchResults(tripviewModel: TripViewModel, success:@escaping ((Results, Data) -> Void), failure:@escaping ((String) -> Void)) {
        let searchURL: URL = URL(string: "https://sit- nativeapps.ryanair.com/api/v4/Availability?origin=\(tripviewModel.origin.value)&destination=\(tripviewModel.destination.value)&dateout=\(tripviewModel.departure)&datein=&flexdaysbeforeout=3&flexdaysout=3&flexdaysbeforein=3&flexdaysin=3&adt=\(tripviewModel.adults.value)&teen=\(tripviewModel.teen.value)&chd=\(tripviewModel.children.value)&roundtrip=false")!
        Alamofire.request(searchURL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default).responseData { (response) in
                response.result.ifSuccess({
                    if let jsonData = response.data {
                        let res = APIResponse(json: jsonData)
                        
                        let decoder = JSONDecoder()
                        do {
                            let results = try decoder.decode(Results.self, from: res.json)
                            print(results)
                            return success(results, res.json)
                        } catch {
                            print("Unexpected error: JSON parsing error")
                            return failure(res.errorMessage ?? "Unexpected error: Unknown error")
                        }
                        
                    } else {
                        failure("Unexpected error: Error parsing response")
                    }
                })
                response.result.ifFailure({
                    failure("Failed")
                    
                })
        }
    }
    
    func getStations(success:@escaping ((Stations, Data) -> Void), failure:@escaping ((String) -> Void)) {
        let stationsURL: URL = URL(string: "https://tripstest.ryanair.com/static/stations.json")!
        Alamofire.request(stationsURL,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default).responseData { (response) in
                            response.result.ifSuccess({
                                if let jsonData = response.data {
                                    let res = APIResponse(json: jsonData)
                                    
                                    let decoder = JSONDecoder()
                                    do {
                                        let stations = try decoder.decode(Stations.self, from: res.json)
                                        print(stations)
                                        return success(stations, res.json)
                                    } catch {
                                        print("Unexpected error: JSON parsing error")
                                        return failure(res.errorMessage ?? "Unexpected error: Unknown error")
                                    }
                                    
                                } else {
                                    failure("Unexpected error: Error parsing response")
                                }
                            })
                            response.result.ifFailure({
                                failure("Failed")
                                
                            })
        }
        
    }
}
