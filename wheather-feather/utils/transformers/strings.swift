//
//  getUrlStringFromCoordinates.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation
import CoreLocation

func getUrlString(from coordinates: CLLocationCoordinate2D) -> String {
    // should not use more than 4 decimals according to the docs
    let latString = getCoordString(coor: coordinates.latitude)
    let lonString = getCoordString(coor: coordinates.longitude)
    let urlString = "\(baseUrl)?lat=\(latString)&lon=\(lonString)"
    return urlString
}

func getCoordString(coor: CLLocationDegrees) -> String {
    return String(format: "%.4f", coor)
}

func printDataSize(_ data: Data) {
    let bcf = ByteCountFormatter()
    bcf.countStyle = .file
    let string = bcf.string(fromByteCount: Int64(data.count))
    print("Data size: \(string)")
}

func formatSummary(for summary: String) -> String {
        
    var trimmedSummary = summary
    if let index = summary.range(of: "_")?.lowerBound {
        trimmedSummary = String(summary.prefix(upTo: index))
    }
    
    var summarySentence: String = ""
    
    let words = [
        "heavy",
        "light",
        "partly",
        "clear",
        "cloudy",
        "fair",
        "fog",
        "sky",
        "rain",
        "sleet",
        "snow",
        "showers",
        "and",
        "thunder",
    ]
    
    for word in words {
        if trimmedSummary.contains(word) {
            summarySentence.append("\(word) ")
        }
    }
    
    let firstLetter = summarySentence.prefix(1).uppercased()
    let rest = summarySentence.dropFirst()
    let formattedSummary =  firstLetter + rest
    
    return formattedSummary
    
}
