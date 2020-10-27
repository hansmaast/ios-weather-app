//
//  HomeViewController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//  Inpired by this post: https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var currentLocationCoordinate: CLLocationCoordinate2D? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Home did load!")
    }
}
