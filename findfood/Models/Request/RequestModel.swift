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
    // MARK: Functions
    
    /// Generates a request for the network call
    ///
    /// - Parameters:
    ///    - page: takes a page number to calculate an offset, then the offset is used to generate a request.
    ///
    /// - Returns: A URL request to be used to make a network call.
    func generateRequest(at page: Int) -> URLRequest? {
        calculateOffset(at: page)
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
    /// Calculates and offset to make the bulk data act as paged.
    ///
    /// - Parameters:
    ///    - page: the current "page" is required so that the next offset can be calculated.
    func calculateOffset(at page: Int) {
        offset = limit*page
    }
    /// Resets offset to 0 in order to make a new network call start from
    /// the first result.
    func resetOffset() {
        offset = 0
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
