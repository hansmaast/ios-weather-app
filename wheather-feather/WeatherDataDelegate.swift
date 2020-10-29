//
//  WeatherData.swift
//  wheather-feather
//
//  Created by Hans Maast on 28/10/2020.
//

import Foundation

enum TimeSerieProps {
    case Instant(InstantData)
    case OneHour(OneHoursData)
    case SixHours(SixHoursData)
    case TwelveHours(TwelveHoursData)
}

protocol WeatherDataDelegate {
    
    func getPropertiesOfFirstTimeSerieData(for location: WeatherDataFileName) -> [TimeSerieProps]
    
    func getUpdatedAt(for location: WeatherDataFileName) -> String
    
    func getTwelveHourSummary(for location: WeatherDataFileName) -> String?
    
    func isRainNextTwelveHours(for location: WeatherDataFileName) -> Bool

    func getHomeText() -> String
    
}

// TODO: It is currently fetching all data in cache for each function call.
// Maybe it should fetch the data to a static variable, and then get the data from that variable?
extension RootController: WeatherDataDelegate {
    func getPropertiesOfFirstTimeSerieData(for location: WeatherDataFileName) -> [TimeSerieProps] {
        let firstTimeserie = getWeatherDataFromCache(fileName: location)!.properties.timeseries[0].data
        
        let props: [TimeSerieProps] = [
            .Instant(firstTimeserie.instant!),
            .OneHour(firstTimeserie.next_1_hours!),
            .SixHours(firstTimeserie.next_6_hours!),
            .TwelveHours(firstTimeserie.next_12_hours!),
        ]
        
        return props
    }
    
    func getTimeSerieAt(index: Int, for location: WeatherDataFileName) -> Timeserie {
        return getWeatherDataFromCache(fileName: location)!.properties.timeseries[index]
    }
  
    func getUpdatedAt(for location: WeatherDataFileName) -> String {
        
        let updateAt = getWeatherDataFromCache(fileName: location)!.properties.meta.updated_at
        
        let date = convertIsoTo(date: updateAt)!
        
        return getDateString(from: date)
        
    }
    
    func getTwelveHourSummary(for location: WeatherDataFileName ) -> String? {
        
        if let data = getWeatherDataFromCache(fileName: .currentLocation)?.properties.timeseries[0].data,
           let iconName = data.next_12_hours?.summary?.symbol_code {
            return iconName
        }
        
        return nil
        
    }

    
    func isRainNextTwelveHours(for location: WeatherDataFileName) -> Bool {
        
        let summary = getTwelveHourSummary(for: location)
        
        return summary!.contains("rain")
        
    }

    func getHomeText() -> String {
        if isRainNextTwelveHours(for: .currentLocation) {
            return "Don´t forget yout umbrella today! ☔️ Its supposed to rain.."
        } else {
            return "Hooray! No rain today! 🔆"
        }
    }
    
}
