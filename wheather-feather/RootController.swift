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
        
        self.tabBar.barTintColor = .white
        
        let homeViewController = HomeViewController()
        homeViewController.delegate = self
        homeViewController.title = "Home"
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
        
        let forecastViewController = ForecastViewController()
        forecastViewController.delegate = self
        forecastViewController.title = "Weather"
        forecastViewController.tabBarItem = UITabBarItem(title: "Weather", image: nil, selectedImage: nil)
        
        let mapViewController = MapViewController()
        mapViewController.delegate = self
        mapViewController.title = "Map"
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
        
        // TODO: Switch these back
        let controllers = [forecastViewController, homeViewController, mapViewController]
        
        controllers.map { $0.view.backgroundColor = .white }
        
        // Maps a navigation controller to each of the "main" controllers
        self.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }

    }
    
}
