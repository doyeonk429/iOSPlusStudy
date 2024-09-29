//
//  Weather.swift
//  Weatherly
//
//  Created by Mohammad Azam on 11/2/23.
//

import Foundation

struct WeatherResponse: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
}
