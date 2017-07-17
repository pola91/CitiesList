//
//  MapViewController.swift
//  CitiesListing
//
//  Created by Jean Joseph on 7/16/17.
//  Copyright © 2017 Jean Joseph. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var location:CityLocation?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var region = MKCoordinateRegion()
        region.center.latitude = Double((location?.lat)!)!
        region.center.longitude = Double((location?.long)!)!
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        let point = MKPointAnnotation()
        point.coordinate = region.center
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(point)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
