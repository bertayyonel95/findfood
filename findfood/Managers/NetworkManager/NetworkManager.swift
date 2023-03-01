//
//  NetworkManager.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import Foundation

protocol Networking{
    func request(request: RequestModel, at page: Int, completion: @escaping (Result<[LocationModel], APIError>) -> Void)
}

//MARK: - NetworkManager
class NetworkManager: Networking {
    
    //MARK: Properties
    private let session: URLSession
    private let locationURL = Constant.API.url
    private let headers = [
      "accept": "application/json",
      "Authorization": "Bearer " + Constant.API.key
    ]
    
    var delegate: HomeViewModel?
    
    //MARK: Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    
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
    
    func parseJSON(_ locationData: Data) -> [LocationModel]? {
        let decoder = JSONDecoder()
        var locationArray: [LocationModel] = []
        do {

            let decodedData = try decoder.decode(Business.self, from: locationData)
            
            // SwiftLint eklenecek
            
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
}


