//
//  saveToCache.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation

func saveToCache(data: Data, fileName: WeatherDataFileName, completion: FetchFromApiCompletion) {
    
    if let url = getCacheUrl()?.appendingPathComponent(fileName.rawValue) {
        
        if FileManager
            .default
            .createFile(atPath: url.path, contents: data, attributes: nil) {
            
            switch fileName {
            case .currentLocation:
                CurrentLocationWeather.shared.updateWeatherData()
            case .specificLocation:
                SpecificLocationWeather.shared.updateWeatherData()
            }
            
            print("Sucsess!💾")
            
            completion(nil)
        }
        else {
            print("Could not save to disk..")
            completion(WeatherError.general(msg: "Could not save to disk.."))
        }
        
    }
}
