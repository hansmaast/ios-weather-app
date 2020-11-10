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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
            setupLocationManager()
            
            fetchDataFrom(coordinates: Locations.shared.specific,
                          saveToCacheAs: .specificLocation,
                          completion: { error, data in
                            
                            guard error == nil else {
                                print("💥💥💥💥")
                                print(error!)
                                return
                            }
                            print("🎓Fetched data for HK!")
                            SpecificLocationWeather.shared = SpecificLocationWeather()
                            NotificationCenter.default.post(name: WeatherDataNotifications.specificLocationFetchDone, object: nil)
                          })
        
        return true
    }
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
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

