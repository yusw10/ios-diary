//
//  NetworkingError.swift
//  Diary
//
//  Created by minsson on 2022/09/04.
//

enum NetworkingError: Error {
    case decodingJSONFailure
    case invalidURL
    case clientTransport
    case serverSideInvalidResponse
    case missingData
    case unknown
}
