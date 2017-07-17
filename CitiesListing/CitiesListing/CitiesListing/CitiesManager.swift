//
//  CitiesData.swift
//  CitiesListing
//
//  Created by Jean Joseph on 7/16/17.
//  Copyright © 2017 Jean Joseph. All rights reserved.
//

import UIKit

class CitiesManager: NSObject {
    static let sharedInstance = CitiesManager()
    var pageIndex = 1
    var citiesDictionary = NSMutableDictionary()
    var citiesArray = NSMutableArray()

    func getMoreCities(completion:@escaping ([IndexPath])->Void){
        let citiesService = WSGetCities()
        citiesService.getCitiesWith(page: pageIndex) { (cities: [[String : AnyObject]]) in
            self.pageIndex += 1
            
            for city in cities{
                let cityObj = City()
                cityObj.country = city["country"] as! String?
                cityObj.name = city["name"] as! String?
                cityObj.id = city["_id"] as! String?
                cityObj.location.long = city["coord"]?["lon"] as! String?
                cityObj.location.lat = city["coord"]?["lat"] as! String?
                self.citiesDictionary.setValue(cityObj, forKey: cityObj.name!)
                let newIndex = self.citiesArray.index(of: cityObj.name ?? "", inSortedRange: NSMakeRange(0, self.citiesArray.count), options: .insertionIndex, usingComparator:{ (name1, name2) -> ComparisonResult in
                    let cityName1 = name1 as! String
                    let cityName2 = name2 as! String
                    if(cityName1 > cityName2){
                        return ComparisonResult.orderedDescending
                    }else{
                        return ComparisonResult.orderedAscending
                    }
                })
                
                self.citiesArray.insert(cityObj.name ?? "", at: newIndex)
                FilterManager.sharedInstance.compliesToFilter(cityKey: cityObj.name!)
            }
            
            
            completion(FilterManager.sharedInstance.setNewIndexPathes())
            
        }
    
    }

}
