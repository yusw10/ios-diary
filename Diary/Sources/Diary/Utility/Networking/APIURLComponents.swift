//
//  APIURLComponents.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/09/04.
//

import CoreLocation

enum APIURLComponents {
    
    private enum WeatherAPI {
        static let openWeatherAPI = "http://api.openweathermap.org"
        static let boryWeatherAPIKey = "59df1d9ac01127d4ccba473c6dd62a32"
    }
    
    // MARK: - Static Properties
    
    static var openWeatherURLComponents = URLComponents(
        string: WeatherAPI.openWeatherAPI
    )
    
    static var openWeatherIconURLComponents = URLComponents(
        string: WeatherAPI.openWeatherAPI
    )
    
    // MARK: - Static Actions

    static func configureWeatherQueryItem(location: Location) {
        openWeatherURLComponents?.path = "/data/2.5/weather"
        openWeatherURLComponents?.queryItems = [
            "lat": "\(location.latitude)",
            "lon": "\(location.longitude)",
            "appid": "\(WeatherAPI.boryWeatherAPIKey)"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    static func configureWeatherIconPath(of icon: String) {
        let iconImage = "\(icon)@2x.png"
        openWeatherIconURLComponents?.path = "/img/wn/\(iconImage)"
    }
}

struct Location {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}
