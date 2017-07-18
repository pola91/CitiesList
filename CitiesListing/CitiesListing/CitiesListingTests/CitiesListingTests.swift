//
//  CitiesListingTests.swift
//  CitiesListingTests
//
//  Created by Jean Joseph on 7/16/17.
//  Copyright © 2017 Jean Joseph. All rights reserved.
//

import XCTest
@testable import CitiesListing

class CitiesListingTests: XCTestCase {
    var searchFilters = ["a","al","as","El","'","?"]
    var searchResults = [["Alexandria","Assiut","Aswan"],["Alexandria"],["Assiut","Aswan"],["El-Behira","El-Minya"],[],[]]
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        CitiesManager.sharedInstance.citiesArray = ["Alexandria","Assiut","Aswan","Cairo","Damnhour","El-Behira","El-Minya"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSearch() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var count = 0
        for filter in searchFilters{
            FilterManager.sharedInstance.filterCities(with: filter)
            var resultCount = 0
            let thisResults = searchResults[count]
            for result in FilterManager.sharedInstance.filteredCitiesArray{
                let thisResult = thisResults[resultCount]
                
                XCTAssertEqual(result as? String, thisResult, "incorrect search")

                resultCount += 1
            }
            count += 1
        }
    }
    
    func testCurrentFilterCompliance() {
        let newEntries = ["Ismaielia","El-Wady El-Gideed","Port Saied"]
        let newFilteredArray = ["El-Behira","El-Minya","El-Wady El-Gideed"]
        
        FilterManager.sharedInstance.filterCities(with:"el")
        for newEntry in newEntries{
            FilterManager.sharedInstance.doesComplyToCurrentFilter(cityKey: newEntry)
        }
        var resultCount = 0
        for result in FilterManager.sharedInstance.filteredCitiesArray{
            XCTAssertEqual(result as? String, newFilteredArray[resultCount], "incorrect Filter")
            resultCount+=1
        }
    }
    
   
    
}
