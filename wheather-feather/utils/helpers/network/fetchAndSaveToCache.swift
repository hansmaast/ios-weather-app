//
//  fetchAndSaveToCache.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation

func fetchAndSaveToCache(from url: String, cacheFileName: WeatherDataFileName, completion: @escaping FetchFromApiCompletion) {
    print("⏺ ⏺ ⏺ Here")
    if let response = fetchData(from: url, completion: completion) {
        print("⏺ ⏺ ⏺")
        debugPrint(response)
        // save result to disk
        saveToCache(data: response, fileName: cacheFileName, completion: completion)
        
    }
}
