//
//  AppDelegate.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
            setupLocationManager()
            
            fetchDataFrom(coordinates: Locations.shared.specific,
                          saveToCacheAs: .specificLocation,
                          completion: { error, data in
                            
                            guard error == nil else {
                                print(error!)
                                return
                            }
                            
                            print("🎓Fetched data for HK!")
                            SpecificLocationWeather.shared = SpecificLocationWeather()
                            NotificationCenter.default.post(name: WeatherDataNotifications.specificLocationFetchDone, object: nil)
                          })
        
        return true
    }
    
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocationCoordinates = manager.location?.coordinate else {
            print("Could not get current location..")
            return
        }
        
        Locations.shared.current = currentLocationCoordinates
        
        fetchDataFrom(coordinates: currentLocationCoordinates, saveToCacheAs: .currentLocation, completion: {error, data in
            
            if let error = error {
                print("💥💥💥💥")
            
                let errDict:[String: Error] = ["error": error]
                
                NotificationCenter.default.post(name: WeatherDataNotifications.fetchFailed, object: nil, userInfo: errDict)
                return
            }
            
            print("📍Fetched data for current location!")
            CurrentLocationWeather.shared = CurrentLocationWeather()
            NotificationCenter.default.post(name: WeatherDataNotifications.currentLocationFetchDone, object: nil)
        })
        
        NotificationCenter.default.post(name: WeatherDataNotifications.currentLocationUpdated, object: nil)
    }
    
    func setupLocationManager() {
        print("Setting up CLM!")
        let locationManager = self.locationManager
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
}

