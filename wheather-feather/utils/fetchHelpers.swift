//
//  helpers.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//  Inspired by this video:
//  https://www.youtube.com/watch?v=sqo844saoC4&ab_channel=iOSAcademy

import Foundation

let baseUrl = "https://api.met.no/weatherapi/locationforecast/2.0/compact"
let urlKristiania = "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=59.911166&lon=10.744810"

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

func printDataSize(_ data: Data) {
    let bcf = ByteCountFormatter()
    bcf.countStyle = .file
    let string = bcf.string(fromByteCount: Int64(data.count))
    print("Data size: \(string)")
}
