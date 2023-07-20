//
//  RequestModel.swift
//  findfood
//
//  Created by Bertay Yönel on 24.01.2023.
//
// swiftlint:disable force_cast

import Foundation

class RequestModel {
    // MARK: Properties
    var offset = 0
    var limit = 20
    var path: String {
        .empty
    }
    var parameters: [String: Any?] {
        [
            "limit": limit.stringValue,
            "offset": offset.stringValue
        ]
    }
    var headers: [String: String] {
        [
            "accept": "application/json",
            "Authorization": "Bearer " + Constant.API.key
        ]
    }
}

extension RequestModel {
    // MARK: Helpers
    
    /// Generates a request for the network call
    ///
    /// - Returns: A URL request to be used to make a network call.
    func generateRequest() -> URLRequest? {
        guard let url = generateURL(with: generateQueryItems()) else { return nil }
        var request = URLRequest(url: url)
        headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
    func generateRequest(with locationID: String) -> URLRequest? {
        guard let url = generateURLWithLocationID(with: generateQueryItems(), locationID: locationID) else { return nil }
        var request = URLRequest(url: url)
        headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
}
private extension RequestModel {
    // MARK: Private Functions
    func generateURL(with queryItems: [URLQueryItem]) -> URL? {
        let endpoint = Constant.API.urlSearch.appending(path)
        var urlComponents = URLComponents(string: endpoint)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return nil }
        return url
    }
    func generateURLWithLocationID(with queryItems: [URLQueryItem], locationID: String) -> URL? {
        let endpoint = Constant.API.url + locationID
        var urlComponents = URLComponents(string: endpoint)
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }
        guard let url = urlComponents?.url else { return nil }
        return url
    }
    /// Generates queries with the parameters
    /// found in the "parameters" array of the model.
    ///
    /// - Returns: An array created with the model's parameters
    func generateQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        parameters.forEach { parameter in
            let value = parameter.value as! String
            queryItems.append(.init(name: parameter.key, value: value))
        }
        return queryItems
    }
}
