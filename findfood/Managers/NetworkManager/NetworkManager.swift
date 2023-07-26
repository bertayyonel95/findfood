//
//  NetworkManager.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import Foundation

protocol Networking {
    func request<T: Decodable>(request: RequestModel, completion: @escaping (Result<T, APIError>) -> Void)
    func requestWithLocationID(request: LocationIDRequest, completion: @escaping (Result<Location, APIError>) -> Void)
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
    
    func requestWithLocationID(request: LocationIDRequest, completion: @escaping (Result<Location, APIError>) -> Void) {
        LoadingManager.shared.show()
        guard let generatedRequest = request.generateRequest(with: request.locationID) else { return }
        let task = session.dataTask(with: generatedRequest) { data, response, error in
            LoadingManager.shared.hide()
            if error != nil || data == nil {
                completion(.failure(.unknownError))
            }
            guard let data = data else { return }
            if let location = self.parseJSONSingle(data) {
                completion(.success(location))
            } else {
                completion(.failure(.notFound))
            }
        }
        task.resume()
    }
    
    /// Parses data retrieved from the network call. Parsed data is then used by the
    /// location models.
    ///
    /// - Parameters:
    ///    - locationData: data to be parsed.
    ///
    /// - Returns: an array with LocationModels.
    func parseJSON(_ locationData: Data) -> [Location]? /* -> T? */ {
        let decoder = JSONDecoder()
        var locationArray: [Location] = []
        do {
            let decodedData = try decoder.decode(Business.self, from: locationData)
            print(decodedData.total)
            for business in decodedData.businesses {
                let location = Location(with: business)
                locationArray.append(location)
            }
            return locationArray
        } catch let error {
            print(error.localizedDescription + "parse error")
            return []
        }
    }
    
    func parseJSONSingle(_ locationData: Data) -> Location? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LocationData.self, from: locationData)
            let location = Location(with: decodedData)
            return location
        } catch let error {
            print(error.localizedDescription + "parse error single")
            return nil
        }
    }
}
