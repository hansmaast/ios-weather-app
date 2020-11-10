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
            
            print("Sucsess!💾")
            
            completion(nil, data)
        }
        else {
            print("Could not save to disk..")
            completion(WeatherError.general(msg: "Could not save to disk.."), data)
        }
        
    }
}
