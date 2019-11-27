//
//  Weather.swift
//  Clima
//
//  Created by Antonio Orozco on 11/21/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let contitionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        
        return String(format:"%.1f" ,temperature)
        
    }
    
    var conditionName: String {
        
       switch contitionId {
              case 200...232:
                  return "cloud.bold"
              case 300...321:
                  return "cloud.drizzle"
              case 500...531:
                  return "cloud.rain"
              case 600...622:
                  return "cloud.snow"
              case 700...781:
                  return "cloud.fog"
              case 800:
                  return "sun.max"
              case 800...804:
                  return "cloud.bolt"
              default:
                  return "cloud"
              }
        
    }
    
}



