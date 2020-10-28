//
//  dateAndTimeHelpers.swift
//  wheather-feather
//
//  Created by Hans Maast on 28/10/2020.
//

import Foundation

enum FormatError: Error {
    case invalidFormat(_ msg: String)
}

let dateFormatter = DateFormatter()

func getDateString(from date: Date) -> String {
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    dateFormatter.locale = Locale(identifier: "en_GB")
    let string = dateFormatter.string(from: date)
    
    return string
}

func getNameOfDay(for date: Date) -> String {
    
    dateFormatter.dateFormat = "EEEE"
    
    return dateFormatter.string(from: date)
}

func convertIsoTo(date: String) -> Date? {
    
    let isoFormatter = ISO8601DateFormatter()
    
    if let date = isoFormatter.date(from: date) {
        return date
    }
    print(FormatError.invalidFormat("The format of the date is not recognized.."))
    return nil
}

func getNameOfDayFromIsoDate(string: String) -> String? {
    
        let date = convertIsoTo(date: string)!
    
        return getNameOfDay(for: date)
}
