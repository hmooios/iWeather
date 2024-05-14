//
//  ViewController.swift
//  iWeather
//
//  Created by Hmoo Myat Theingi on 04/05/2024.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var dayLabelOne: UILabel!
    @IBOutlet weak var dayLabelTwo: UILabel!
    @IBOutlet weak var dayLabelThree: UILabel!
    
    @IBOutlet weak var maxTempOne: UILabel!
    @IBOutlet weak var minTempOne: UILabel!
    
    @IBOutlet weak var maxTempTwo: UILabel!
    @IBOutlet weak var minTempTwo: UILabel!
    
    @IBOutlet weak var maxTempThree: UILabel!
    @IBOutlet weak var minTempThree: UILabel!
    
    
    @IBOutlet weak var conditionImageOne: UIImageView!
    @IBOutlet weak var conditionImageTwo: UIImageView!
    @IBOutlet weak var conditionImageThree: UIImageView!
    
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    
    var weatherViewModel = WeatherViewModel()
    var cllocationManger = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherViewModel.delegate = self
        cllocationManger.delegate = self
        
        viewOne.layer.cornerRadius = viewOne.frame.size.height / 2
        viewTwo.layer.cornerRadius = 10
        
        cllocationManger.requestWhenInUseAuthorization()
        cllocationManger.requestLocation()
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        cllocationManger.requestLocation()
        
    }
   
 
    
}
//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        }else{
            searchTextField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = searchTextField.text {
            weatherViewModel.fetchWeather(cityName: name)
        }
        searchTextField.text = ""
    }

}

//MARK: - WeatherViewModelDelegate

extension WeatherViewController: WeatherViewModelDelegate {
    func didUpdateWeather(_ weatherViewModel: WeatherViewModel, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherConditionImage.image = UIImage(named: conditionImage(weather.conditionID))
            self.temperatureLabel.text = "\(weather.temperatureString)°C"
            self.cityLabel.text = weather.cityName
            self.maximumTemperatureLabel.text = "\(weather.maxTemp)°C"
            self.minimumTemperatureLabel.text = "\(weather.minTemp)°C"
            self.rainLabel.text = "\(weather.rain)"
            self.humidityLabel.text = weather.humidityString
            self.windLabel.text = "\(weather.windSpeedString)km/h"
            self.dayLabelOne.text = convertDate(weather.dateOne)
            self.dayLabelTwo.text = convertDate(weather.dateTwo)
            self.dayLabelThree.text = convertDate(weather.dateThree)
            self.maxTempOne.text = "\(formattedTemp(weather.maxTemp))°"
            self.minTempOne.text = "\(formattedTemp(weather.minTemp))°"
            self.maxTempTwo.text = "\(formattedTemp(weather.maxTempTwo))°"
            self.minTempTwo.text = "\(formattedTemp(weather.minTempTwo))°"
            self.maxTempThree.text = "\(formattedTemp(weather.maxTempThree))°"
            self.minTempThree.text = "\(formattedTemp(weather.minTempThree))°"
            self.conditionImageOne.image = UIImage(named: conditionImage(weather.conditionID))
            self.conditionImageTwo.image = UIImage(named: conditionImage(weather.conditionIDTwo))
            self.conditionImageThree.image = UIImage(named: conditionImage(weather.conditionIDThree))
        }
        print("didUpdateWeather")
    }
    
    func didFailWithError(error: Error) {
        print("Fail updating with error  \(error.localizedDescription)")
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            if let location = locations.last {
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                
                self.weatherViewModel.fetchWeather(lat: lat, lon: lon)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location failed.")
    }
}


//MARK: - Private funcitons

func convertDate(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    if let dateObject = dateFormatter.date(from: dateString) {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "h:mm a"
        hourFormatter.amSymbol = "AM"
        hourFormatter.pmSymbol = "PM"
        return hourFormatter.string(from: dateObject)
    } else {
        return "Invalid Date"
    }
}

func formattedTemp(_ temp: Double) -> String {
    return String(format: "%.1f", temp)
}


func conditionImage(_ conditionID: Int) -> String {
        switch conditionID {
        case 200...232:
            return "thunder"
        case 300...321:
            return "raindrop"
        case 500...531:
            return "bigRainDrops"
        case 600...622:
            return "snow"
        case 701...781:
            return "atmosphere"
        case 800:
            return "clearSky"
        default:
            return "clouds"
        }
    
}
