//
//  fetchAndSaveToCache.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation

func fetchAndSaveToCache(from url: String, cacheFileName: WeatherDataFileName, completion: @escaping FetchFromApiCompletion) {

    fetchData(from: url) { error, data in
        
        if let error = error {
            print("Error:")
            print(error)
            completion(error, data)
        }
        
        if let data = data {
            // save result to disk
            saveToCache(data: data, fileName: cacheFileName, completion: completion)
        }
        
                
    }
}
