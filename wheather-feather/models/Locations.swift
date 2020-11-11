//
//  Locations.swift
//  wheather-feather
//
//  Created by Hans Maast on 27/10/2020.
//

import Foundation
import CoreLocation

struct Locations {
    
    // sets specific location to HK coordinates
    private init() { self.specific = Coordinates.HK }
    static var shared = Locations()
    
    var specific: CLLocationCoordinate2D? = nil
    var pinLocation: CLLocationCoordinate2D? = nil
    var current: CLLocationCoordinate2D? = Coordinates.HK 
    
}
