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

func fetchAndSaveToCache(from url: String, cacheFileName: WeatherDataFileName) {
    
    let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
        
        guard let data = data, error == nil else {
            print("Something went wrong while trying to fetch data..")
            return
        }
        
        // If we get down her we have data
        print("Fetching some: \(type(of: data))")
        printDataSize(data)
        
        // save result to disk
        saveToCache(data: data, fileName: cacheFileName)
        
        /* TODO: Remove this, if we dont need it
        do {
            result = try JSONDecoder().decode(MetApiResponse.self, from: data)
        }
        catch {
            print("failed to convert \(error.localizedDescription)")
        }
        
        guard let json = result else { return }
        */
        
        /*
        print("Geometry -> \(json.geometry.coordinates)")
        print("Units -> \(json.properties.meta.units)")
        print("First time serie -> \(json.properties.timeseries[0].time)")
        print("Time series count -> \(json.properties.timeseries.count)")
        print("First 1 hours -> \(String(describing: json.properties.timeseries[0].data.next_1_hours?.summary?.symbol_code))")
        */
    
    })
    
    task.resume()
}

func getDataForLocation(coords: CLLocationCoordinate2D?, saveToCacheAs: WeatherDataFileName) {
    guard let coordinates = coords else {
        print("Coords is nil")
        return
    }
    
    // should not use more than 4 decimals according to the docs
    let latString = getCoordString(coor: coordinates.latitude)
    let lonString = getCoordString(coor: coordinates.longitude)
    
    let url = "\(baseUrl)?lat=\(latString)&lon=\(lonString)"
    
    fetchAndSaveToCache(from: url, cacheFileName: saveToCacheAs)
    
    print("Fetching for location \(latString) / \(lonString)")
}


func checkIfModifiedSince() {
        
    var req = URLRequest(url: URL(string: urlKristiania)!)
    req.setValue("Tue, 27 Oct 2020 13:36:47 GMT", forHTTPHeaderField: "If-Modified-Since")
    
    let task = URLSession.shared.dataTask(with: req) { data, response, error  in
        guard error == nil else {
            print("Error: \(String(describing: error))")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse {
            print("Metadata: \(httpStatus.statusCode)")
        }
    }
    
    task.resume()
    
    /*
    $ curl -A "MyTestApp/0.1" -i -H 'If-Modified-Since: Tue, 16 Jun 2020 12:11:59 GMT' \
      -s 'https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=51.5&lon=0'
    HTTP/1.1 304 Not Modified
    Content-Type: application/json
    */
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
