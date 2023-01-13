//
//  NetworkManager.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import Foundation

protocol NetworkManagerDelegate {
    func didGetLocation(_ networkManager: NetworkManager, _ location: [LocationModel])
}

//MARK: - NetworkManager
class NetworkManager {
    
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
    
    func requestBusiness(city cityName: String) {
        let urlString = "\(locationURL)location=\(cityName.urlEncoded()!)&sort_by=best_match&categories=cafes,seafood,restaurant,pub,coffee,desserts,kebab,bars&limit=35"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = session.dataTask(with: request as URLRequest) { [unowned self] data, response, error in
            
            if error != nil {
                print(error?.localizedDescription, #file)
                return
            }
            
            if let data {
                if let location = self.parseJSON(data) {
                    self.delegate?.didGetLocation(self, location)
                }
            }
        }

        dataTask.resume()
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
            print(error.localizedDescription)
            return []
        }
    }
}


