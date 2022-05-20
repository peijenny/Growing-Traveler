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
        
        // given
        let yesterday = Date(timeIntervalSince1970: 1652976000)
        
        let sevenDaysArray = ["05.13", "05.14", "05.15", "05.16", "05.17", "05.18", "05.19"]
        
        // when
        sut.handleSevenDays(yesterday: yesterday)
        
        // then
        XCTAssertEqual(sut.sevenDaysArray, sevenDaysArray, "Time isn't yesterday.")
        
    }
    
    func testPerformance() {
        
        measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTStorageMetric(), XCTMemoryMetric()]) {
            
            let yesterday = Date(timeIntervalSince1970: 1652976000)
            
            sut.handleSevenDays(yesterday: yesterday)
            
        }
        
    }

}
