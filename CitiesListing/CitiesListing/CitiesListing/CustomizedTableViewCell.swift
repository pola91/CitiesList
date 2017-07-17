//
//  CustomizedTableViewCell.swift
//  CitiesListing
//
//  Created by Jean Joseph on 7/16/17.
//  Copyright © 2017 Jean Joseph. All rights reserved.
//

import UIKit

class CustomizedTableViewCell: UITableViewCell {

    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    var longLat:NSString?
    override func awakeFromNib() {
        super.awakeFromNib()
        mapImage.layer.cornerRadius = 5
        mapImage.layer.borderWidth = 1
        mapImage.layer.borderColor = UIColor.darkGray.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
