//
//  helpers.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//

import Foundation

func getData(from url: String) {
   let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
        
        guard let data = data, error == nil else {
            print("Something went wrong while trying to fetch data..")
            return
        }
        
        // If we get down her we have data
    debugPrint(data)
        var result: Response?
        do {
            result = try JSONDecoder().decode(Response.self, from: data)
        }
        catch {
            print("failed to convert \(error.localizedDescription)")
        }
        
        guard let json = result else { return }
        
    print("Geometry -> \(json.geometry.coordinates)")
    print("Units -> \(json.properties.meta.units)")
    print("First time serie -> \(json.properties.timeseries[0].time)")
    print("Time series count -> \(json.properties.timeseries.count)")
    print("First 12 hours -> \(String(describing: json.properties.timeseries[0].data.next_12_hours?.summary?.symbol_code))")
        
    })
    
    task.resume()
}
