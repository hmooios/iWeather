//
//  WeatherManager.swift
//  iWeather
//
//  Created by Hmoo Myat Theingi on 05/05/2024.
//

import Foundation
import CoreLocation

protocol WeatherViewModelDelegate {
    func didUpdateWeather(_ weatherViewModel: WeatherViewModel, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherViewModel {
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=e3bc6c7f3e9e51b21ce5e6973f2340f9&units=metric"
    var delegate: WeatherViewModelDelegate?
    
    func fetchWeather(cityName: String) {
        let url = "\(weatherURL)&q=\(cityName)"
        performRequest(with: url)
    }
    
    func fetchWeather(lat: CLLocationDegrees,lon: CLLocationDegrees) {
        let url = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: url)
    }
    
    func performRequest(with url: String){
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, urlResponse, error in
                if error != nil {
                    return
                }
                   
                if let safeData = data {
                    if let weather = parseJSON(data: safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                        
                    }
            }
            task.resume()
            
        }
    }
    
    func parseJSON(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.list[0].weather[0].id
            let name = decodedData.city.name
            let temp = decodedData.list[0].main.temp
            let minTemp = decodedData.list[0].main.temp_min
            let maxTemp = decodedData.list[0].main.temp_max
            let rain = decodedData.list[0].rain?.the3H
            let humidity = decodedData.list[0].main.humidity
            let wind = decodedData.list[0].wind.speed
            let dateOne = decodedData.list[0].dt_txt
            let dateTwo = decodedData.list[2].dt_txt
            let dateThree = decodedData.list[4].dt_txt
            let minTempTwo = decodedData.list[2].main.temp_min
            let maxTempTwo = decodedData.list[2].main.temp_max
            let minTempThree = decodedData.list[4].main.temp_min
            let maxTempThree = decodedData.list[4].main.temp_max
            let conditionIDTwo = decodedData.list[2].weather[0].id
            let conditionIDThree = decodedData.list[4].weather[0].id

            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp, minTemp: minTemp, maxTemp: maxTemp, rain: rain ?? 0, humidity: humidity, wind: wind,dateOne: dateOne, dateTwo: dateTwo,dateThree: dateThree, minTempOne: minTemp,maxTempOne: maxTemp,minTempTwo: minTempTwo,maxTempTwo: maxTempTwo,minTempThree: minTempThree,maxTempThree: maxTempThree,conditionIDTwo: conditionIDTwo,conditionIDThree: conditionIDThree)
            print(id)
            print(conditionIDTwo)
            print(conditionIDThree)
            return weather
        } catch  {
            print("Error decoding data!\(error.localizedDescription)")
            print("Raw JSON data: \(String(data: data, encoding: .utf8) ?? "")")
            return nil
        }
        
        
    }
}
