//
//  RyanAirBookingsTestTests.swift
//  RyanAirBookingsTestTests
//
//  Created by Ben Smith on 31/10/2018.
//  Copyright © 2018 Ben Smith. All rights reserved.
//

import XCTest
@testable import RyanAirBookingsTest

class RyanAirBookingsTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testParsingForTestURLWorks() {
        //We should def get results if this parser works: https://sit-nativeapps.ryanair.com/api/v4/Availability?origin=DUB&destination=STN&dateout=2018-12-12&datein=&flexdaysbeforeout=3&flexdaysout=3&flexdaysbeforein=3&flexdaysin=3&adt=1&teen=0&chd=0&roundtrip=false&ToUs=AGREED
        let tripViewModel = TripViewModel.init(origin: "DUB", destination: "STN", departure: "2018-12-12", adults: "1", teen: "0", children: "0")
        DataAccess.shared.getSearchResults(tripviewModel: tripViewModel, success: { (trips, data) in
            XCTAssertNil(trips.count > 0, "Got trips as expected")
        }) { (message) in
            XCTFail()
        }
    }
    
    func testParseWorksWithTetsJSON() {
        
        if let url = Bundle.main.url(forResource: "trip", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                let res = APIResponse(json: data)

                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(Results.self, from: res.json)
                    print(results)
                    XCTAssert(results.trips.count > 0)
                } catch {
                    print("Unexpected error: JSON parsing error")
                    XCTFail()
                }

            } else {
                XCTFail()
            }

        }
    }
    func testParsingForTestURLFails() {
        //We should def get results if this parser works: https://sit-nativeapps.ryanair.com/api/v4/Availability?origin=DUB&destination=STN&dateout=2018-12-12&datein=&flexdaysbeforeout=3&flexdaysout=3&flexdaysbeforein=3&flexdaysin=3&adt=1&teen=0&chd=0&roundtrip=false&ToUs=AGREED
        let tripViewModel = TripViewModel.init(origin: "DUB", destination: "STN", departure: "e", adults: "1", teen: "0", children: "0")
        sleep(2)
        DataAccess.shared.getSearchResults(tripviewModel: tripViewModel, success: { (trips, data) in
            XCTFail()
        }) { (message) in
            XCTAssert(true)
        }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
