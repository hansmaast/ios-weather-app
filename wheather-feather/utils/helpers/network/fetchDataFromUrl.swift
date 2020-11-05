//
//  fetchDataFromUrl.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation

func fetchData(from urlString: String, completion: @escaping FetchFromApiCompletion) -> Data? {
    
    var response: Data?
    
    let session = URLSession.shared
    
    guard let url = URL(string: urlString) else {
        print("The url passed in is not valid..")
        return nil
    }
    
    let task = session.dataTask(with: url) { data, res, error in
       
        if let error = error {
            print("Something went wrong while trying to fetch data..")
            print(error.localizedDescription)
            completion(error)
            return
        }
        
        guard let data = data else {
            return
        }
        
        // If we get down her we have data
        print("Fetching some: \(type(of: data))")
        printDataSize(data)
        
        response = data
        
    }
    
    task.resume()
    
    completion(nil)
    
    return response
}
