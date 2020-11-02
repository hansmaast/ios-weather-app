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

struct WeatherDataNotifications {
    
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
        
        self.ApiResponse = getWeatherDataFromCache(fileName: location)!
        
        self.updatetAt = ApiResponse.properties.meta.updated_at
        
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
    
    let updatetAt: String
    
    let coordinates: CLLocationCoordinate2D
    
    let units: Units
    
    let timeSeries: [Timeserie]
    
    let firstTimeserie: Timeserie
    
    let instant: InstantData
    
    let nextOneHour: OneHoursData
    
    let nextSixHours: SixHoursData
    
    let nextTwelveHours: TwelveHoursData
    
}
