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
    let locationURL = Constant.API.url
    let headers = [
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
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
            return
          }
            if let safeData = data {
                if let location = self.parseJSON(safeData) {
                    self.delegate?.didGetLocation(self, location)
                }
            }
        })

        dataTask.resume()
    }
    
    func parseJSON(_ locationData: Data) -> [LocationModel]? {
        let decoder = JSONDecoder()
        var locationArray: [LocationModel] = []
        do {
            let decodedData = try decoder.decode(Business.self, from: locationData)
            for business in decodedData.businesses {
                let id = business.id
                let name = business.name
                let categories = business.categories
                let price = business.price ?? .empty
                let rating = String(format: "%.1f", business.rating ?? 0.0)
                let image_url = business.image_url
                let display_phone = business.display_phone
                let display_address = business.location.display_address ?? []
                
                let location = LocationModel(locationID: id, locationName: name, locationRating: rating, locatinImageLink: image_url, locationPrice: price, locationCategories: categories, display_phone: display_phone, display_address: display_address)
                locationArray.append(location)
            }
            return locationArray
        } catch {
            print(error)
            return []
        }
    }
}


