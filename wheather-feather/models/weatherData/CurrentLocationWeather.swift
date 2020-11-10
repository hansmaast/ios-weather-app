//
//  CurrentLocationWeather.swift
//  wheather-feather
//
//  Created by Hans Maast on 02/11/2020.
//

import Foundation

class CurrentLocationWeather: WeatherData {
    
    init() {
        super.init(for: .currentLocation)
    }
    
    static var shared: CurrentLocationWeather?
    
}

extension CurrentLocationWeather: WeatherDataDelegate {
    
    func updateWeatherData() {
        
        // Resets the instance
        CurrentLocationWeather.shared = CurrentLocationWeather()
    }
    
    
    func getPropertiesOfFirstTimeSerieData() -> [TimeSerieProps]? {
        
        if let instant = firstTimeserie?.data.instant,
           let oneHour = firstTimeserie?.data.next_1_hours,
           let sixHours = firstTimeserie?.data.next_6_hours,
           let twelveHours = firstTimeserie?.data.next_12_hours
        {
            let props: [TimeSerieProps] = [
                .Instant(instant),
                .OneHour(oneHour),
                .SixHours(sixHours),
                .TwelveHours(twelveHours),
            ]
            
            return props
        }
        
        return nil
    }
    
    func getTimeSerieAt(index: Int) -> Timeserie? {
        return timeSeries?[index]
    }
    
    func getUpdatedAt() -> String? {
        if let isoString = updatedAt {
            if let date = convertIsoTo(date: isoString) {
                return getDateString(from: date)
            }
        }
        
        return nil
    }
    
    func getTwelveHourSymbolCode() -> String? {
        
        if let symbolCode = nextTwelveHours?.summary?.symbol_code {
            return symbolCode
        }
        
        return nil
        
    }
    
    
    func isRainNextTwelveHours() -> Bool {
        
        let summary = getTwelveHourSymbolCode()
        
        return summary!.contains("rain")
        
    }
    
    func getHomeText() -> String {
        if isRainNextTwelveHours() {
            return "Don´t forget yout umbrella today! ☔️ Its supposed to rain.."
        } else {
            return "Hooray! No rain today! 🔆"
        }
    }
    
}
