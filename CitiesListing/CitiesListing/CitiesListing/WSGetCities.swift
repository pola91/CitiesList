//
//  WSGetCities.swift
//  CitiesListing
//
//  Created by Jean Joseph on 7/16/17.
//  Copyright © 2017 Jean Joseph. All rights reserved.
//

import UIKit

class WSGetCities: NSObject {
    
    func getCitiesWith(page: Int, completion: @escaping ( _ cities: [[String: AnyObject]]) -> Void){
        var request = URLRequest(url: URL(string: String(format:"http://assignment.pharos-solutions.de/cities.json?page=%d", page))!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                
            }
            
            do{

            let returnedCities = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]]
                completion(returnedCities!)
            } catch {

            }

        }
        task.resume()
    
    }
}
