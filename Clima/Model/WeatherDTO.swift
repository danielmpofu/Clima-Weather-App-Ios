//
//  WeatherDTO.swift
//  Clima
//
//  Created by Daniel T Mpofu on 27/3/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation;

struct WeatherDTO {
    let id: Int;
    let name: String;
    let temp: Double;
    let waetherName: String ;
    let weatherDescription: String;
    
    var icon : String {
        switch id {
        case 200 ... 231:
            return "cloud.bolt";
            
        case 300 ... 321:
            return "cloud.drizzle";
            
        case 500 ... 531:
            return "cloud.rain";
            
        case 600 ... 622:
            return "cloud.snow";
            
        case 800:
            return "sun.max";
            
        case 801 ... 804:
            return "cloud.bolt";
            
        default:
            return "cloud";
        }
    };
}
