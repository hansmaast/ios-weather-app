//
//  getUrlStringFromCoordinates.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//
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
