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
        
        setupLocationManager()
        
        print("Home did load!")
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let locactionCoordinates = manager.location?.coordinate else {
            print("Could not get current location..")
            return
        }
        getDataForCurrentPosition(coords: locactionCoordinates)
        print("Current Location = \(locactionCoordinates.latitude) / \(locactionCoordinates.longitude)")
        getWeatherDataFromCache(fileName: .currentLocation)
    }
    
}

extension HomeViewController {
    func setupLocationManager() {
        let locationManager = self.locationManager
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func getDataForCurrentPosition(coords: CLLocationCoordinate2D?) {
        guard let coordinates = coords else {
            print("Coords is nil")
            return
        }
        
        let url = "\(baseUrl)?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)"
        
        fetchAndSaveToCache(from: url, cacheFileName: .currentLocation)
        
        print("Get data for: \(url)")
    }
}
