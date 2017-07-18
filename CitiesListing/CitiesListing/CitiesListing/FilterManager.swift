//
//  FilterManager.swift
//  CitiesListing
//
//  Created by Jean Joseph on 7/16/17.
//  Copyright © 2017 Jean Joseph. All rights reserved.
//

import UIKit

class FilterManager: NSObject {
    static let sharedInstance = FilterManager()
    var filteredCitiesArray = NSMutableArray()
    var filterKey = ""
    var citiesNewlyInserted = NSMutableArray()
    
    func filterCities(with:String){
        filterKey = with
        filteredCitiesArray = NSMutableArray()
        citiesNewlyInserted = NSMutableArray()
        
        if( with.characters.count == 0){
            var count = 0
            for city in CitiesManager.sharedInstance.citiesArray{
                filteredCitiesArray.add(city)
                citiesNewlyInserted.add("f")
                count += 1
            }
        }else{

            filteredCitiesArray = NSMutableArray()
            for city in CitiesManager.sharedInstance.citiesArray{
                let cityKey = city as! String
                let withLowerCases = with.lowercased()
                let cityKeyLowerCases = cityKey.lowercased()
                if (cityKeyLowerCases.hasPrefix(withLowerCases)) {
                    filteredCitiesArray.add(cityKey)
                    citiesNewlyInserted.add("f")
                }
            }
        }
    }
    
    func findCityIndex(with:String)->Int{
        var count = 0
        for city in self.filteredCitiesArray{
            let cityKey = city as! String
            if (cityKey.isEqual(with)) {
                return count
            }
            count += 1
        }
        return count
    }
    
    func doesComplyToCurrentFilter(cityKey:String){
        var doesComply = false
        
        if(filterKey.characters.count == 0){
            doesComply = true
        }
        
        let withLowerCases = filterKey.lowercased()
        let cityKeyLowerCases = cityKey.lowercased()
        if (cityKeyLowerCases.hasPrefix(withLowerCases)) {
            doesComply = true
        }
        if(doesComply){
            let newIndex = self.filteredCitiesArray.index(of: cityKey , inSortedRange: NSMakeRange(0, self.filteredCitiesArray.count), options: .insertionIndex, usingComparator:{ (name1, name2) -> ComparisonResult in
                let cityName1 = name1 as! String
                let cityName2 = name2 as! String
                let cityName1Lowered = cityName1.lowercased()
                let cityName2Lowered = cityName2.lowercased()
                
                if(cityName1Lowered > cityName2Lowered){
                    return ComparisonResult.orderedDescending
                }else{
                    return ComparisonResult.orderedAscending
                }

            })
            
            filteredCitiesArray.insert(cityKey , at: newIndex)
            citiesNewlyInserted.insert("t" , at: newIndex)

        }
    }
    
    
    func setNewIndexPathes()->[IndexPath]{
        var counter = 0
        var indexPathes = [IndexPath]()
        for cityNewlyInserted in self.citiesNewlyInserted{
            let str = cityNewlyInserted as! String
            if(str == "t"){
                let newIndexPath = IndexPath.init(row: counter, section: 0)
                indexPathes.append(newIndexPath)
                self.citiesNewlyInserted[counter] = "f"

            }
            counter += 1
        }
        return indexPathes
    }
}
