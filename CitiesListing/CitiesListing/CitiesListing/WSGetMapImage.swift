//
//  WSGetMapImage.swift
//  CitiesListing
//
//  Created by Jean Joseph on 7/16/17.
//  Copyright © 2017 Jean Joseph. All rights reserved.
//

import UIKit

class WSGetMapImage: NSObject {
    
    
    func getMapImageWith(longitude: String, latitude: String, completion: @escaping (_ image:UIImage, _ longitude: String, _ latitude: String) -> Void){
        let urlStr = "http://maps.google.com/maps/api/staticmap?markers=color:red|\(latitude),\(longitude)&\("zoom=16&size=150x150")&sensor=true"
        let urlStrEdited : String = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: urlStrEdited)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let image =  UIImage(data:data!)
            completion(image!, longitude, latitude)
            
        }
        task.resume()
        
    }

}
