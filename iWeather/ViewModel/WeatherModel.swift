//
//  WeatherDataViewModel.swift
//  iWeather
//
//  Created by Hmoo Myat Theingi on 05/05/2024.
//

import Foundation

struct WeatherModel: Codable {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    let minTemp: Double
    let maxTemp: Double
    let rain: Double
    let humidity: Int
    let wind: Double
    let dateOne: String
    let dateTwo: String
    let dateThree: String
    
    let minTempOne: Double
    let maxTempOne: Double
    
    let minTempTwo: Double
    let maxTempTwo: Double
    
    let minTempThree: Double
    let maxTempThree: Double
    
    let conditionIDTwo: Int
    let conditionIDThree: Int
    
    var convertedWindSpeed: Double {
        return wind * 3.6
    }
    
    var windSpeedString: String {
        return String(format: "%.1f", convertedWindSpeed)
    }
    var humidityString: String{
        return String(format: "%.1f", humidity)
    }
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
}
