//
//  getDataFromCache.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation

func getDataFromCache(fileName: WeatherDataFileName) throws -> MetApiResponse? {
    
    let url = getCacheUrl()!.appendingPathComponent(fileName.rawValue)
    
    if let json = FileManager.default.contents(atPath: url.path),
       FileManager.default.fileExists(atPath: url.path) {
        
        do {
            print("Getting data from cache....")
            let weatherData = try decodeJSON(to: MetApiResponse.self, from: json)
            return weatherData
        } catch {
            throw(error)
        }
        
    }
    else {
        
        var urlString: String
        switch fileName {
        case .currentLocation:
            urlString = getUrlString(from: Locations.shared.current!)
        case .specificLocation:
            urlString = getUrlString(from: Locations.shared.specific!)
        }
        
        fetchAndSaveToCache(from: urlString,
                            cacheFileName: fileName,
                            completion: { error, data in
                                
                                if let data = data {
                                    print("Ding dong data: \(data)")
                                    
                                   let weatherData = try! decodeJSON(to: MetApiResponse.self, from: data)
                                    
                                    if fileName == .currentLocation {
                                        CurrentLocationWeather.shared = CurrentLocationWeather()
                                    }
                                    else {
                                        SpecificLocationWeather.shared?.updateWeatherData()
                                    }
                                }
                                
                                if let error = error {
                                    print(error)
                                }
                                
                                
                            })
        
        print(WeatherError.general(msg: "No data at location: \(url.path)"))
        return nil
        
    }
}
