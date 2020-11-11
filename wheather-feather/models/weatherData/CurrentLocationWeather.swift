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
        self.forecastDaysWithStartingIndex = self.getStartingIndexOfDays()
    }
    
    static var shared: CurrentLocationWeather?
    
    var forecastDaysWithStartingIndex: [[String: Int]]?
    
}

extension CurrentLocationWeather: WeatherDataDelegate {
    
    func updateWeatherData() {
        
        // Resets the instance
        CurrentLocationWeather.shared = CurrentLocationWeather()
    }
    
    func getStartingIndexOfDays() -> [[String: Int]]? {
        
        let now = Date.init()
        print(now)
        
        guard timeSeries != nil else { return nil }
        
        var currentDay = getNameOfDay(for: convertIsoTo(date: timeSeries![0].time)!)
        
        var  daysStartingIndex: [[String: Int]] = [[currentDay: 0]]
        
        for (i,t) in timeSeries!.enumerated() {
            if let date = convertIsoTo(date: t.time) {
                let day = getNameOfDay(for: date)
                if currentDay !=  day {
                    currentDay = day
                    daysStartingIndex.append([currentDay: i])
                }
            }
        }
        
        print(daysStartingIndex)
        print("Number of days: \(daysStartingIndex.count)")
        
        return daysStartingIndex

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
