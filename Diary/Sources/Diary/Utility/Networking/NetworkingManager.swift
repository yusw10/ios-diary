//
//  NetworkingManager.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/09/04.
//

import Foundation

struct NetworkingManager {
    
    // MARK: - Static Actions
    
    static func execute(
        _ networkRequest: URLRequest,
        completion: @escaping (Result<Data, NetworkingError>) -> Void
    ) {
        
        let task = URLSession.shared.dataTask(with: networkRequest) { data, response, error in
            if error != nil {
                return completion(.failure(.clientTransport))
            }
            
            guard isValidResponse(response) else {
                return completion(.failure(.serverSideInvalidResponse))
            }
            
            guard let data = data else {
                return completion(.failure(.missingData))
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}

// MARK: - Private Static Actions

private extension NetworkingManager {
    static func isValidResponse(_ response: URLResponse?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            return false
        }
        
        return true
    }
}
