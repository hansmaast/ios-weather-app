//
//  Errors.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

enum WeatherError: Error {
    case fetch(msg: String, code: Int? = nil)
    case general(msg: String)
}
