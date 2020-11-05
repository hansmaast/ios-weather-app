//
//  WeaterData.swift
//  wheather-feather
//
//  Created by Hans Maast on 02/11/2020.
//

import Foundation
import CoreLocation

protocol WeatherDataDelegate {
    
    func getPropertiesOfFirstTimeSerieData() -> [TimeSerieProps]?
    
    func getUpdatedAt() -> String
    
    func getTwelveHourSymbolCode() -> String?
    
    func isRainNextTwelveHours() -> Bool
    
    func getHomeText() -> String
    
    func updateWeatherData()
    
}


/**
 Inspired by the code from this article:
 https://www.raywenderlich.com/5371-grand-central-dispatch-tutorial-for-swift-4-part-2-2
 */
struct WeatherDataNotifications {
    
    static let fetchFailed = Notification.Name("currentLocationUpdate")
    static let currentLocationUpdated = Notification.Name("currentLocationUpdate")
    
}


enum TimeSerieProps {
    case Instant(InstantData)
    case OneHour(OneHoursData)
    case SixHours(SixHoursData)
    case TwelveHours(TwelveHoursData)
}

class WeatherData {
    
    init(for location: WeatherDataFileName) {
        
        print("🕋 🕋")
        
        self.ApiResponse = try! getDataFromCache(fileName: location)!
        
        self.updatedAt = ApiResponse.properties.meta.updated_at
        
        self.coordinates = CLLocationCoordinate2D(
            latitude: ApiResponse.geometry.coordinates[1],
            longitude: ApiResponse.geometry.coordinates[0]
        )
        
        self.units = self.ApiResponse.properties.meta.units
        
        self.timeSeries = self.ApiResponse.properties.timeseries
        
        self.firstTimeserie = (self.timeSeries.first)!
        
        self.instant = self.firstTimeserie.data.instant!
        
        self.nextOneHour = self.firstTimeserie.data.next_1_hours!
        
        self.nextSixHours = self.firstTimeserie.data.next_6_hours!
        
        self.nextTwelveHours = self.firstTimeserie.data.next_12_hours!
        
        print(self.coordinates)
        
    }
    
    var ApiResponse: MetApiResponse
    
    var updatedAt: String
    
    var coordinates: CLLocationCoordinate2D
    
    var units: Units
    
    var timeSeries: [Timeserie]
    
    var firstTimeserie: Timeserie
    
    var instant: InstantData
    
    var nextOneHour: OneHoursData
    
    var nextSixHours: SixHoursData
    
    var nextTwelveHours: TwelveHoursData
    
}
