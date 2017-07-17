//
//  ViewController.swift
//  CitiesListing
//
//  Created by Jean Joseph on 7/16/17.
//  Copyright © 2017 Jean Joseph. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    
    @IBOutlet weak var searchingTxtField: UITextField!
    let cache = NSCache<NSString, UIImage>()
    
    var selectedLocation = CityLocation()
    let selectedLon = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchingTxtField.delegate = self
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        let nib = UINib(nibName: "CustomizedTableViewCell", bundle: nil)
        searchingTxtField.layer.borderWidth = 1
        searchingTxtField.layer.borderColor = UIColor.lightGray.cgColor
        searchingTxtField.layer.cornerRadius = 5
        searchingTxtField.placeholder = "Search Cities"
        citiesTableView.register(nib, forCellReuseIdentifier: "myCell")
        citiesTableView.separatorStyle = .none
        let citiesMan = CitiesManager.sharedInstance
        DispatchQueue.global().async {
            citiesMan.getMoreCities(completion: {(indexPaths:[IndexPath]) in
                DispatchQueue.main.async(execute:{
                    self.citiesTableView.reloadData()
                })
            })
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.global().async {
            let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            FilterManager.sharedInstance.filterCities(with: newString)
            DispatchQueue.main.async(execute:{
                
                self.citiesTableView.reloadData()
            })
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityKey = FilterManager.sharedInstance.filteredCitiesArray[indexPath.item]
        let city = CitiesManager.sharedInstance.citiesDictionary.object(forKey: cityKey) as! City
        selectedLocation = city.location
        self.performSegue(withIdentifier: "ToMap", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMap" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.location = selectedLocation
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier:"myCell") as? CustomizedTableViewCell
        if (cell == nil) {
            cell = CustomizedTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "myCell")
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        let cityKey = FilterManager.sharedInstance.filteredCitiesArray[indexPath.item]
        let cityObj = CitiesManager.sharedInstance.citiesDictionary.object(forKey: cityKey) as! City
        cell?.cityName.text = cityObj.name
        cell?.countryName.text = cityObj.country
        cell?.mapImage.image = UIImage(named: "default")
        let lonLat = cityObj.location.long!+cityObj.location.lat!
        cell?.longLat = lonLat as NSString
        var myObject: UIImage = UIImage()
        let cacheKey = cell?.longLat
        if let cachedVersion = cache.object(forKey: cacheKey! ) {
            // use the cached version
            myObject = cachedVersion
            cell?.mapImage.image = myObject

        } else {
            // create it from scratch then store in the cache
            DispatchQueue.global().async {
                let imageGetter = WSGetMapImage()
                imageGetter.getMapImageWith(longitude: cityObj.location.long!, latitude: cityObj.location.lat!, completion: { (image,lon,lat) in
                    DispatchQueue.main.async(execute:{
                        let cacheKeyNew = lon + lat
                        self.cache.setObject(image, forKey: cacheKeyNew as NSString)

                        if(cell?.longLat == lon+lat as NSString){
                            cell?.mapImage.image = image

                        }
                    })
                    
                })
            }

        }
        
        
        
        return cell!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterManager.sharedInstance.filteredCitiesArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height) {
            let lastCityKey = FilterManager.sharedInstance.filteredCitiesArray[FilterManager.sharedInstance.filteredCitiesArray.count - 1]
            DispatchQueue.global().async {
                CitiesManager.sharedInstance.getMoreCities(completion: {(indexPaths:[IndexPath]) in
                    DispatchQueue.main.async(execute:{
                        
                        //NOTE TO EVALUATOR
                            //for the requirement in hand there is no difference
                            //between using TableView.reloadData() and
                            //TableView.insertRows(), since TableView.reloadData()
                            //only reloads the apparant cells  however
                            //TableView.insertRows() was used as it doesn't 
                            //flicker providing a smoother and better UX
                        
                        
                        //self.citiesTableView.reloadData()
                        if(indexPaths.count == 0){
                            self.showToast(message: "No new Cities for this filter")
                        }else{
                            self.citiesTableView.beginUpdates()
                            self.citiesTableView.insertRows(at: indexPaths, with: .fade)
                            self.citiesTableView.endUpdates()
                            //NOTE TO EVALUATOR
                                //the following code to auto scroll to the last viewed city before retrieving new cities
                            
                            let index = FilterManager.sharedInstance.findCityIndex(with: lastCityKey as! String)
  //                          if(index != FilterManager.sharedInstance.filteredCitiesArray.count - 1){
                                let indexPath = NSIndexPath.init(row:index, section: 0)
                                self.citiesTableView.scrollToRow(at: NSIndexPath.init(row:0, section: 0) as IndexPath, at: .top, animated: false)
                                self.citiesTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
                                
//                            }
                        }})
                })
            }
            
        }
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

