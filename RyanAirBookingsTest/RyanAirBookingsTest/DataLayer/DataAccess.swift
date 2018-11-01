//
//  DataAccess.swift
//  RyanAirBooker
//
//  Created by Ben Smith on 30/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
class APIResponse {
    var json:Data;
    var errorMessage:String?;
    init(json:Data) {
        self.json = json
    }
}
struct Cities: Codable {
    var working_area: [String]?
    var code: String?
    var name: String?
    var country_code: String
}

class DataAccess {
    static let shared = DataAccess()
    

    private init() {
    }
    
    func getSearchResults(tripviewModel: TripViewModel, success:@escaping (([Trips], Data) -> Void), failure:@escaping ((String) -> Void)) {
        
        if let origin = tripviewModel.origin.value,
            let destination = tripviewModel.destination.value,
            let departureDate = tripviewModel.departure.value,
            let adults = tripviewModel.adults.value,
            let children = tripviewModel.children.value,
            let teens = tripviewModel.teen.value,
            
            let searchURL: URL = URL(string: "https://sit-nativeapps.ryanair.com/api/v4/Availability?origin=\(origin)&destination=\(destination)&dateout=\(departureDate)&datein=&flexdaysbeforeout=3&flexdaysout=3&flexdaysbeforein=3&flexdaysin=3&adt=\(adults == "" ? "0" : adults)&teen=\(teens == "" ? "0" : teens)&chd=\(children == "" ? "0" : children)&roundtrip=false&ToUs=AGREED"){
            SVProgressHUD.show()
            Alamofire.request(searchURL,
                              method: .get,
                              parameters: nil,
                              encoding: JSONEncoding.default).responseData { (response) in
                                response.result.ifSuccess({
                                    SVProgressHUD.dismiss()

                                    if let jsonData = response.data {
                                        let res = APIResponse(json: jsonData)

                                        let decoder = JSONDecoder()
                                        do {
                                            let results = try decoder.decode(Results.self, from: res.json)
                                            print(results)
                                            return success(results.trips, res.json)
                                        } catch {
                                            print("Unexpected error: JSON parsing error")
                                            return failure(res.errorMessage ?? "Unexpected error: Unknown error")
                                        }

                                    } else {
                                        SVProgressHUD.dismiss()

                                        return failure("Unexpected error: Error parsing response")
                                    }
                                })
                                response.result.ifFailure({
                                    SVProgressHUD.dismiss()

                                    return failure("Failed")

                                })
            }
        }

    }
    
    func getStations(success:@escaping (([Stations], Data) -> Void), failure:@escaping ((String) -> Void)) {
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
                                        let stationList = try decoder.decode(StationList.self, from: jsonData)
                                        
                                        print(stationList.stations)
                                        
                                        return success(stationList.stations, res.json)
                                    } catch {
                                        print("Unexpected error: JSON parsing error")
                                        return failure(res.errorMessage ?? "Unexpected error: Unknown error")
                                    }
                                    
                                } else {
                                    return failure("Unexpected error: Error parsing response")
                                }
                            })
                            response.result.ifFailure({
                                return failure("Failed")
                                
                            })
        }
        
    }
}
