//
//  APIRequest.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/09/04.
//

import Foundation

struct APIRequest {
    
    // MARK: - Life Cycles
    
    init(url: URL, httpMethod: HTTPMethod, body: Data?) {
        self.url = url
        self.httpMethod = httpMethod
        self.body = body
    }
    
    // MARK: - Properties
    
    private var url: URL
    private var httpMethod: HTTPMethod
    private var body: Data?
    
    // MARK: - Actions
    
    func createURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.httpMethod.rawValue
        urlRequest.httpBody = self.body
        return urlRequest
    }
}
