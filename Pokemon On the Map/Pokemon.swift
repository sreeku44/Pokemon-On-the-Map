//
//  Pokemon.swift
//  Pokemon On the Map
//
//  Created by Sreekala Santhakumari on 3/13/17.
//  Copyright © 2017 Klas. All rights reserved.
//

import Foundation

class Pokemon {

    var name : String
    var imageURL :String
    var latitude : Double
    var longitude : Double
    
    init(name:String, imageURL:String , latitude:Double, longitude:Double ) {
        
        self.name = name
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
        
    }


}
