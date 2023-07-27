//
//  NetworkManager.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import Foundation

protocol Networking {
    func request<T: Decodable>(request: RequestModel, completion: @escaping (Result<T, APIError>) -> Void)
}

// MARK: - NetworkManager
class NetworkManager: Networking {
    // MARK: Properties
    private let session: URLSession
    // MARK: Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    // MARK: Helpers
    /// Request data with the provided request mode from the database.
    ///
    /// - Parameters:
    ///    - request: request model to be used to make a network request.
    func request<T: Decodable>(request: RequestModel, completion: @escaping (Result<T, APIError>) -> Void) {
        var generatedRequest: URLRequest?
        if !request.locationID.isEmpty {
            generatedRequest = request.generateRequest(with: request.locationID)
        } else {
            generatedRequest = request.generateRequest()
        }
        let task = session.dataTask(with: generatedRequest!) { data, response, error in
            if let error {
                completion(.failure(.unknownError))
                return
            }
            guard let data else {
                completion(.failure(.unknownError))
                return
            }
            do {
                let convertedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(convertedData))
            } catch {
                completion(.failure(.unknownError))
            }
        }
        task.resume()
    }
}
