//
//  Weather.swift
//  Diary
//
//  Created by 유한석 on 2022/09/01.
//

import Foundation

// MARK: - Welcome
struct WeatherModel: Codable {
    let weather: [Weather]
}


// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
