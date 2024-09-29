//
//  Location.swift
//  Weatherly
//
//  Created by Mohammad Azam on 11/2/23.
//

import Foundation

struct Location: Decodable {
    let name: String
    let lat: Double
    let lon: Double
}
