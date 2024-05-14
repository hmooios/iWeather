//
//  WeatherData.swift
//  iWeather
//
//  Created by Hmoo Myat Theingi on 05/05/2024.
//

import Foundation

struct WeatherData: Codable {
    let list: [WeatherListItem]
    let city: City
}

struct WeatherListItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let dt_txt: String
   let rain: Rain?
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct City: Codable {
    let name: String
    let country: String
}

struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Wind: Codable {
    let speed: Double
 
}



