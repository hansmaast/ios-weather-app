//
//  fetchDataFromUrl.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation

func fetchData(from urlString: String, completion: @escaping FetchFromApiCompletion) {
    
    guard let url = URL(string: urlString) else {
        print("The url passed in is not valid..")
        return 
    }
    
    print("Im in the fetch..")
    print(url)
    
    let task = URLSession.shared.dataTask(with: url) { data, res, error in
        
        print("Im in the task..")
        if let error = error {
            print("Something went wrong while trying to fetch data..")
            print(error.localizedDescription)
            completion(error, data)
            return
        }
        
        if let data = data {

        // If we get down her we have data
        print("Fetching some: \(type(of: data))")
        printDataSize(data)
            
        completion(error, data)
            
        } else {
            print("There is no data!")
        }
        
    }
    
    task.resume()
}
