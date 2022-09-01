//
//  Network.swift
//  Diary
//
//  Created by 유한석 on 2022/08/31.
//

import Foundation

class WeatherNetworkManager {
    
    static let shared = WeatherNetworkManager()
    
    private init() {}
    
    
    func requestWeatherData(location: Location){
        //?lat=38.0129678&lon=46.7718772&appid=59df1d9ac01127d4ccba473c6dd62a32
        let urlString = WeatherAPI.weatherURL + "?lat=\(location.latitude)&lon=\(location.longitude)" + "&appid=\(WeatherAPI.boryWeatheAPi)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("error 1")
                return
            }
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else {
                print("error 2")
                return
            }
            
            guard let resultData = data else {
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(WeatherModel.self, from: resultData)
                print("@@@@@@@")
                print(decodedData.weather.first?.main)
                print(decodedData.weather.first?.icon)
            } catch {
                print("히히")
            }
        }.resume()
    }
}
