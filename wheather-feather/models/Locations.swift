//
//  Locations.swift
//  wheather-feather
//
//  Created by Hans Maast on 27/10/2020.
//

import Foundation
import CoreLocation

struct Coordinates {
    private init(){}
    static let shared = Coordinates()
    let HK = CLLocationCoordinate2D(latitude: 59.911166, longitude: 10.744810)
}

struct Locations {
    
    // sets specific location to HK coordinates
    private init() { self.specific = Coordinates.shared.HK }
    static var shared = Locations()
    
    var specific: CLLocationCoordinate2D? = nil
    var pinLocation: CLLocationCoordinate2D? = nil
    var current: CLLocationCoordinate2D? = nil {
        didSet {
            // do something when a new location is set
            print("New Location set!")
        }
    }
    
}
