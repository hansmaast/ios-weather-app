//
//  helpers.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//  Inspired by this video:
//  https://www.youtube.com/watch?v=sqo844saoC4&ab_channel=iOSAcademy

import Foundation
import CoreLocation

let baseUrl = "https://api.met.no/weatherapi/locationforecast/2.0/compact"

let urlKristiania = "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=59.9112&lon=10.7448"

func fetchAndSaveToCache(from url: String, cacheFileName: WeatherDataFileName, completion: @escaping FetchFromApiCompletion) {
    
    let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
        
        guard let data = data, error == nil else {
            print("Something went wrong while trying to fetch data..")
            print(error?.localizedDescription)
            
            completion(error)
            return
        }
        
        // If we get down her we have data
        print("Fetching some: \(type(of: data))")
        printDataSize(data)
        
        // save result to disk
        saveToCache(data: data, fileName: cacheFileName, completion: completion)
        
    })
    
    task.resume()
}

enum FetchError: Error {
    case failed(msg: String, code: Int? = nil)
}

typealias FetchFromApiCompletion = (_ error: Error? ) -> ()

func fetchDataForLocation(coords: CLLocationCoordinate2D?, saveToCacheAs: WeatherDataFileName, completion: @escaping FetchFromApiCompletion) {
    guard let coordinates = coords else {
        print("Coords is nil")
        return
    }
    
    // should not use more than 4 decimals according to the docs
    let latString = getCoordString(coor: coordinates.latitude)
    let lonString = getCoordString(coor: coordinates.longitude)
    
    let url = "\(baseUrl)?lat=\(latString)&lon=\(lonString)"
    
    fetchAndSaveToCache(from: url, cacheFileName: saveToCacheAs, completion: completion)
    
    print("Fetching for location \(latString) / \(lonString)")
}

func getCoordString(coor: CLLocationDegrees) -> String {
    return String(format: "%.4f", coor)
}

func printDataSize(_ data: Data) {
    let bcf = ByteCountFormatter()
    bcf.countStyle = .file
    let string = bcf.string(fromByteCount: Int64(data.count))
    print("Data size: \(string)")
}
