//
//  DiaryItem.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/17.
//

import Foundation

struct DiaryItem: Decodable, Hashable {
    
    // MARK: - Properties
    
    var title: String
    var body: String
    let createdDate: TimeInterval
    let uuid: UUID
    var weather: String
    var weatherIconId: String
    
    // MARK: - Enums(CodingKeys)
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdDate = "created_at"
        case uuid
        case weather
        case weatherIconId = "weather_icon_id"
    }
}
