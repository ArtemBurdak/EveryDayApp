//
//  WeatherStruct.swift
//  EveryDayApp
//
//  Created by Artem on 2/7/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import Foundation

struct WeatherJson: Codable {
    let coord: Coordinates
    let weather: [WeatherType]
    let main: TemperatureParams
    let wind: WindSpeed
    let clouds: Clouds
    let sys: CountryAndSun
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

struct WeatherType: Codable {
    let id: Int
    let description: String
    let icon: String
}

struct TemperatureParams: Codable {
    let temp: Double
    let humidity: Double
}

struct WindSpeed: Codable {
    let speed: Double
}

struct Clouds: Codable {
    let all: Double
}

struct CountryAndSun: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}
