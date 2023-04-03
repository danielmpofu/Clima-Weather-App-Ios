//
//  WeatherData.swift
//  Clima
//
//  Created by Daniel T Mpofu on 26/3/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
struct WeatherDeta : Codable{
    let name: String;
    let main: Main;
    let weather: [WeatherItem];
    
}

struct Main : Codable{
    let temp: Double;
}

struct WeatherItem : Codable{
    let id: Int;
    let main: String;
    let description: String;
    let icon : String;
}

