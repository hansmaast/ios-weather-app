//
//  Locations.swift
//  wheather-feather
//
//  Created by Hans Maast on 27/10/2020.
//

import Foundation
import CoreLocation

struct Locations {
    
    static var shared = Locations()
    
    var hkLocation = CLLocationCoordinate2D(latitude: 59.911166, longitude: 10.744810)
    var pinLocation: CLLocationCoordinate2D? = nil
    var myLocation: CLLocationCoordinate2D? = nil {
        didSet {
            print("New Location set!")
        }
    }
    
}
