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
    
    
    func requestRegionCode(regionCode: String){
        //q=KR&appid=59df1d9ac01127d4ccba473c6dd62a32
        let urlString = WeatherAPI.coordinateURL + "?q=\(regionCode)" + "&appid=\(WeatherAPI.boryWeatheAPi)"
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
            print(String(data: resultData, encoding: String.Encoding.utf8))
            do {
                let decodedData = try decoder.decode(MarketList.self, from: resultData)
                print(decodedData)
            } catch {
                print("히히")
            }
        }.resume()
    }
}
