//
//  json.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//
import Foundation

func decodeJSON<T: Decodable>(to model: T.Type, from data: Data) throws -> T {
    let decoder = JSONDecoder()
    do {
        let data = try decoder.decode(model, from: data)
        print("Returning data updated as \(type(of: data))")
        return data
    } catch {
        print(error)
        throw(error)
    }
}
