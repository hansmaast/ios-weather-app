//
//  ForecastViewController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//

import UIKit
import Alamofire

class ForecastViewController: UIViewController {
    
    let url = "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=59.911166&lon=10.744810"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(from: url)
        
        print("Forecast did load!")
    }
}
