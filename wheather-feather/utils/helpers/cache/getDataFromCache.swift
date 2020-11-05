//
//  getDataFromCache.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation

func getDataFromCache(fileName: WeatherDataFileName) throws -> MetApiResponse? {
    
    let url = getCacheUrl()!.appendingPathComponent(fileName.rawValue)
    
    guard let json = FileManager.default.contents(atPath: url.path),
          FileManager.default.fileExists(atPath: url.path)
    else {
        
        print("Going for the fetch 🥊 🥊 🥊")
        var urlString: String
        
        switch fileName {
        case .currentLocation:
            urlString = getUrlString(from: Locations.shared.current!)
        case .specificLocation:
            urlString = getUrlString(from: Locations.shared.specific!)
        }
        var data: MetApiResponse
        
        if let json = fetchData(from: urlString, completion: { error in
            if let error = error {
                print(WeatherError.fetch(msg: error.localizedDescription))
            }
        }) {
            data = try! decodeJSON(to: MetApiResponse.self, from: json)
            
            print(data.properties.meta.updated_at)
            
            return data
            
        }
        print(WeatherError.general(msg: "No data at location: \(url.path)"))
        return nil
    }
    
    do {
        let weatherData = try decodeJSON(to: MetApiResponse.self, from: json)
        return weatherData
    } catch {
        throw(error)
    }
    
}
