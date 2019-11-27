//
//  WeatherManager.swift
//  Clima
//
//  Created by Antonio Orozco on 11/20/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=39af483b4fe5e0eb88afc84218344e11&units=metric"
    
    //let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=39af483b4fe5e0eb88afc84218344e11"
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(String(describing: cityName.folding(options: .diacriticInsensitive, locale: .current)))"
        
        print(urlString)
        
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(lon: CLLocationDegrees , lat: CLLocationDegrees) {
        //lat=20.57&lon=-103.48
        
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        
        print(urlString)
        
        performRequest(with: urlString)
    }

    
    func performRequest(with urlString: String)  {
        
        guard let url = URL(string: urlString) else {
            
            print("Not able to create URL")
            
            return
        }
        
        let session = URLSession(configuration: .default)
                
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
                self.delegate?.didFailWithError(error: error!)
                
                return
            }
            
            guard let safeData = data else {
                
                print("No data")
                
                return
                
            }
            
            guard let weather = self.parseJSON(weatherData: safeData) else {
                
                print("Not able to gather weather")
                
                return
                
            }
            
            self.delegate?.didUpdateWeather(self, weather: weather)
            
        }
        
        task.resume()
        
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            
            let temp = decodedData.main.temp
            
            let name = decodedData.name
            
            return  WeatherModel(contitionId: id, cityName: name, temperature: temp)
            
        } catch {
        
            print(error)
            
            delegate?.didFailWithError(error: error)
            
            return nil
        }
    }
    
}
