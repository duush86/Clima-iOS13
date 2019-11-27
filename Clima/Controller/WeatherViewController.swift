//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locateMe: UIButton!
    
    let locationManager = CLLocationManager()
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        locationManager.delegate = self
                        
        locationManager.startUpdatingLocation()
        
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        searchTextField.delegate = self
    
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        
        guard searchTextField.text != "" else {
                   
            print("Empty text")
                   
            searchTextField.placeholder = "Type Something"
            
            return
                   
        }
        
        print(searchTextField.text!)
               
        searchTextField.endEditing(true)
                
    }
    
    
   
    @IBAction func locateMeButtonTapped(_ sender: UIButton) {
        
        locationManager.startUpdatingLocation()
        
        locationManager.requestLocation()

    }
    
}

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard textField.text != "" else {
            
            print("Empty text")
            
            textField.placeholder = "Type Something"
            
            return false
            
        }
        print(searchTextField.text!)
        
        searchTextField.endEditing(true)

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        if let city = searchTextField.text {
        
            weatherManager.fetchWeather(cityName: city)
        
        }
        
        searchTextField.text = ""
        
    }
    
    
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       
    print("error:: \(error.localizedDescription)")
  
  }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        guard let location = locations.first else {
            
            print("unable to get location")
            
            return
            
        }

        
        print("Location updated to \(location.coordinate.latitude)  \(location.coordinate.longitude)")
        
        

        weatherManager.fetchWeather(lon: Double(round(1000*location.coordinate.longitude)/1000), lat: Double(round(1000*location.coordinate.latitude)/1000))
        
        locationManager.stopUpdatingLocation()
    }
    
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didFailWithError(error: Error) {
        
            print(error)
        
    }
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
           
           //print(weather.temperatureString)
        DispatchQueue.main.sync {
            
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            
        }
        
        
           
    }
    
    
    
}
