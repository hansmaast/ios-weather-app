//
//  constants.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation

let baseUrl = "https://api.met.no/weatherapi/locationforecast/2.0/compact"
let urlKristiania = "\(baseUrl)?lat=59.9112&lon=10.7448"

typealias FetchFromApiCompletion = (_ error: Error?, _ data: Data? ) -> ()

enum WeatherDataFileName: String {
    case currentLocation = "current-location-weatherdata.json"
    case specificLocation = "specific-location-weatherdata.json"
}
