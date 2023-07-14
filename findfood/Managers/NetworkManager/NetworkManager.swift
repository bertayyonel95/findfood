//
//  NetworkManager.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import Foundation

protocol Networking {
    func request(request: RequestModel, at page: Int, completion: @escaping (Result<[LocationModel], APIError>) -> Void)
    func requestWithLocationID(request: LocationIDRequestModel, completion: @escaping (Result<LocationModel, APIError>) -> Void)
}

// MARK: - NetworkManager
class NetworkManager: Networking {
    // MARK: Properties
    private let session: URLSession
    private let headers = [
      "accept": "application/json",
      "Authorization": "Bearer " + Constant.API.key
    ]
    var delegate: HomeViewModel?
    // MARK: Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    // MARK: Functions
    /// Request data with the provided request mode from the database.
    ///
    /// - Parameters:
    ///    - request: request model to be used to make a network request.
    ///    - page: page number for the data.
    func request(request: RequestModel, at page: Int, completion: @escaping (Result<[LocationModel], APIError>) -> Void) {
        guard let generatedRequest = request.generateRequest(at: page) else { return }
        let task = session.dataTask(with: generatedRequest) { data, response, error in
            if error != nil || data == nil { completion(.failure(.unknownError)) }
            guard let data = data else { return }
            if let location = self.parseJSON(data) {
                completion(.success(location))
            }
        }
        task.resume()
    }
    func requestWithLocationID(request: LocationIDRequestModel, completion: @escaping (Result<LocationModel, APIError>) -> Void) {
        LoadingManager.shared.show()
        guard let generatedRequest = request.generateRequest(with: request.locationID) else { return }
        let task = session.dataTask(with: generatedRequest) { data, response, error in
            LoadingManager.shared.hide()
            if error != nil || data == nil { completion(.failure(.unknownError)) }
            guard let data = data else { return }
            if let location = self.parseJSONSingle(data) {
                completion(.success(location))
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
    func parseJSON(_ locationData: Data) -> [LocationModel]? {
        let decoder = JSONDecoder()
        var locationArray: [LocationModel] = []
        do {
            let decodedData = try decoder.decode(Business.self, from: locationData)
            for business in decodedData.businesses {
                let location = LocationModel(with: business)
                locationArray.append(location)
            }
            return locationArray
        } catch let error {
            print(error.localizedDescription + "parse error")
            return []
        }
    }
    
    func parseJSONSingle(_ locationData: Data) -> LocationModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LocationData.self, from: locationData)
            let location = LocationModel(with: decodedData)
            return location
        } catch let error {
            print(error.localizedDescription + "parse error single")
            return nil
        }
    }
}
