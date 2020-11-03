//
//  cacheHelpers.swift
//  wheather-feather
//
//  Created by Hans Maast on 27/10/2020.
//  Inspired by this: https://gist.github.com/saoudrizwan/b7ab1febde724c6f30d8a555ea779140

import Foundation

enum CacheHelperError:Error {
    case error(_ msg: String)
}

enum WeatherDataFileName: String {
    case currentLocation = "current-location-weatherdata.json"
    case specificLocation = "specific-location-weatherdata.json"
}

func saveToCache(data: Data, fileName: WeatherDataFileName, completion: FetchFromApiCompletion) {
    
        
        let url = getCacheUrl()!.appendingPathComponent(fileName.rawValue)
        
        if FileManager
            .default
            .createFile(atPath: url.path, contents: data, attributes: nil) {
            print("Sucsess!💾")
            completion(nil)
        }
        else {
            print("Could not save to disk..")
            completion(FetchError.failed(msg: "Could not save to disk.."))
        }
        
        
}

func getCacheUrl() -> URL? {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls.first
}

func getWeatherDataFromCache(fileName: WeatherDataFileName) -> MetApiResponse? {
        
        let url = getCacheUrl()!.appendingPathComponent(fileName.rawValue)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            print(CacheHelperError.error("No data at location: \(url.path)"))
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            let model = MetApiResponse.self
            do {
                let model = try decoder.decode(model, from: data)
                print("Returning data updated at \(model.properties.meta.updated_at)")
                return model
            } catch {
                print(error)
            }
        }
        else {
            print(CacheHelperError.error("No data at location: \(url.path)"))
        }
        return nil
}

