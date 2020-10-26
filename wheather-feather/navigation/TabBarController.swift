//
//  TabBarController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = .white
        
        let homeViewController = HomeViewController()
        homeViewController.title = "Home"
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
        
        let forecastViewController = ForecastViewController()
        forecastViewController.title = "Weather"
        forecastViewController.tabBarItem = UITabBarItem(title: "Weather", image: nil, selectedImage: nil)
        
        let mapViewController = MapViewController()
        mapViewController.title = "Map"
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
        
        let controllers = [homeViewController, forecastViewController, mapViewController]
        
        // Maps a navigation controller to each of the "main" controllers
        self.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }

    }
    
}
