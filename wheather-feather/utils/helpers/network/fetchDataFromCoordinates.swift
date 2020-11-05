//
//  fetchDataFromCoordinates.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import CoreLocation

func fetchDataFrom(coordinates: CLLocationCoordinate2D?, saveToCacheAs: WeatherDataFileName, completion: @escaping FetchFromApiCompletion) {
    guard let coordinates = coordinates else {
        print("Coords is nil")
        return
    }
        
    let url = getUrlString(from: coordinates)
    
    fetchAndSaveToCache(from: url, cacheFileName: saveToCacheAs, completion: completion)
}
