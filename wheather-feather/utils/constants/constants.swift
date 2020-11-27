
import Foundation
import CoreLocation

let baseUrl = "https://api.met.no/weatherapi/locationforecast/2.0/compact"
let urlKristiania = "\(baseUrl)?lat=59.9112&lon=10.7448"

typealias FetchFromApiCompletion = (_ error: Error?, _ data: Data? ) -> ()

enum WeatherDataFileName: String {
    case currentLocation = "current-location-weatherdata.json"
    case specificLocation = "specific-location-weatherdata.json"
}

struct Coordinates {
    static let HK = CLLocationCoordinate2D(latitude: 59.911166, longitude: 10.744810)
}
