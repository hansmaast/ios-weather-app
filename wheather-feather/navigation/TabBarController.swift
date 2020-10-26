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
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
        
        let forecastViewController = ForecastViewController()
        forecastViewController.tabBarItem = UITabBarItem(title: "Weather", image: nil, selectedImage: nil)
        
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
        
        self.viewControllers = [homeViewController, forecastViewController, mapViewController]

    }
    
}
