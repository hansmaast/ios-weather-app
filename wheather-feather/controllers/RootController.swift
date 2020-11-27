//
//  TabBarController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//

import UIKit

class RootController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reRender),
            name: WeatherDataNotifications.currentLocationFetchDone,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFetchFailed),
            name: WeatherDataNotifications.fetchFailed,
            object: nil)
        

        
        setTabBarFontSize()
        
        self.tabBar.barTintColor = .white
        
        let homeViewController = PageViewController()
        homeViewController.title = "Home"
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
        
        let forecastViewController = ForecastViewController()
        forecastViewController.title = "Weather"
        forecastViewController.tabBarItem = UITabBarItem(title: "Weather", image: nil, selectedImage: nil)
        
        let mapViewController = MapViewController()
        mapViewController.title = "Map"
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
        
        let controllers = [ homeViewController, forecastViewController, mapViewController, ]
        
        let _ = controllers.map { $0.view.backgroundColor = .white }
        
        // Maps a navigation controller to each of the "main" controllers
        self.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
        
    }
    
    @objc func handleFetchFailed() {
        displayAlert(WeatherError.fetch(msg: "Not able to fetch new data.", code: nil), to: self)
    }
    
    @objc func reRender() {
        
        print("Reloading app!")
        
        DispatchQueue.main.async {
            self.viewDidLoad()
        }

    }
    
    func setTabBarFontSize() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 16)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 16)!], for: .selected)
    }
    
}
