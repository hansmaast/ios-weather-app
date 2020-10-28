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
            
        checkIfModifiedSince()
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        setupLocationManager()
        
        print("Fetching data!")
        fetchAndSaveToCache(from: urlKristiania, cacheFileName: .specificLocation)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let currentLocationCoordinates = manager.location?.coordinate else {
            print("Could not get current location..")
            return
        }
        
        Locations.shared.myLocation = currentLocationCoordinates
        
        getDataForLocation(coords: currentLocationCoordinates, saveToCacheAs: .currentLocation)
        
        //getWeatherDataFromCache(fileName: .currentLocation)
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

