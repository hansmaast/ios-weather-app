//
//  response.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//

import Foundation

struct MetApiResponse: Codable {
    let type: String
    let geometry: Geometry
    let properties: Properties
}

struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

struct Properties: Codable {
    let meta: Meta
    let timeseries: [Timeserie]
}

struct Meta: Codable {
    let updated_at: String
    let units: Units
}

struct Units:Codable {
    let air_pressure_at_sea_level: String
    let air_temperature: String
    let cloud_area_fraction: String
    let precipitation_amount: String
    let relative_humidity: String
    let wind_from_direction: String
    let wind_speed: String
}

struct Timeserie:Codable {
    let time: String
    let data: WeatherData
}

struct WeatherData: Codable {
    let instant: InstantData?
    let next_12_hours: TwelveHoursData?
    let next_1_hours: OneHoursData?
    let next_6_hours: SixHoursData?
}

struct InstantData: Codable {
    let details: InstantDetails?
}

struct InstantDetails: Codable {
    let air_pressure_at_sea_level: Float?
    let air_temperature: Float?
    let cloud_area_fraction: Float?
    let relative_humidity: Float?
    let wind_from_direction: Float?
    let wind_speed: Float?
}

struct TwelveHoursData: Codable {
    let summary: Summary?
}

struct OneHoursData: Codable {
    let summary: Summary?
    let details: HourDataDetails?
}

struct SixHoursData: Codable {
    let summary: Summary?
    let details: HourDataDetails?
}

struct Summary: Codable {
    let symbol_code: String?
}

struct HourDataDetails: Codable {
    let precipitation_amount: Double?
}
