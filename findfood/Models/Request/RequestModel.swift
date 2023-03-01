//
//  RequestModel.swift
//  findfood
//
//  Created by Bertay Yönel on 24.01.2023.
//

import Foundation

class RequestModel {
    
    var offset = 0
    
    var limit = 20
    
    var path: String {
        .empty
    }
    
    var parameters: [String: Any?] {
        [
            "limit" : limit.stringValue,
            "offset" : offset.stringValue
        ]
    }
    
    var headers: [String:String] {
        [
            "accept": "application/json",
            "Authorization": "Bearer " + Constant.API.key
        ]
    }
}

extension RequestModel {
    func generateRequest(at page: Int) -> URLRequest? {
        calculateOffset(at: page)
        guard let url = generateURL(with: generateQueryItems()) else { return nil }
        
        var request = URLRequest(url: url)
        headers.forEach{ header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    func calculateOffset(at page: Int) {
        offset = limit*page
    }
    
    func resetOffset() {
        offset = 0
    }
}

private extension RequestModel {
    func generateURL(with queryItems: [URLQueryItem]) -> URL? {
        let endpoint = Constant.API.url.appending(path)
        var urlComponents = URLComponents(string: endpoint)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return nil }
        
        return url
    }
    
    func generateQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        parameters.forEach{ parameter in
            let value = parameter.value as! String
            queryItems.append(.init(name: parameter.key, value: value))
        }
        return queryItems
    }
}
