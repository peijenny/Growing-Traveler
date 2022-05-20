//
//  Growing_TravelerTests.swift
//  Growing-TravelerTests
//
//  Created by Jenny Hung on 2022/5/19.
//

import XCTest
@testable import Growing_Traveler

class GrowingTravelerTests: XCTestCase {
    
    var sut: HandleAnalysisManager!

    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        sut = HandleAnalysisManager()
    }

    override func tearDownWithError() throws {
        
        sut = nil
        
        try super.tearDownWithError()
        
    }
    
    func testTarget() {
        
        let day = 24 * 60 * 60
        
        let yesterday = Date()
            .addingTimeInterval(-Double((day))).addingTimeInterval(Double(day / 3))
        
        let sevenDaysArray = [
            "05.13", "05.14", "05.15", "05.16", "05.17", "05.18", "05.19"]
        
        sut.handleSevenDays(yesterday: yesterday)
        
        XCTAssertEqual(sut.sevenDaysArray, sevenDaysArray, "時間不是昨天")
        
    }
    
    func testPerformance() {
        
        measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTStorageMetric(), XCTMemoryMetric()]) {
            
            let day = 24 * 60 * 60
            
            let yesterday = Date()
                .addingTimeInterval(-Double((day))).addingTimeInterval(Double(day / 3))
            
            sut.handleSevenDays(yesterday: yesterday)
            
        }
        
    }
    
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
