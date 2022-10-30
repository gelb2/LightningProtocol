//
//  HTTPClient.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

enum MINEType: String {
    case JSON = "application/json"
}

enum HTTPHeaders: String {
    case contentType = "Content-Type"
}

enum HTTPError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL, iosDevloperIsStupid
}

protocol HTTPClientProtocol {
    func fetch<T: Codable>(api: API) async throws -> T
    func sendData<T: Codable>(api: API, object: T) async throws
}

class HTTPClient: HTTPClientProtocol {
    
    func fetch<T: Codable>(api: API) async throws -> T {
        let baseComponent = api.urlComponets
        let httpMethod = api.httpMethod.rawValue
        
        guard let url = baseComponent?.url else { throw HTTPError.badURL }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HTTPError.badResponse
        }
        
        guard let object = try? JSONDecoder().decode(T.self, from: data) else {
            throw HTTPError.errorDecodingData
        }
        return object
    }
    
    // TODO: fetch처럼 api enum 받도록 수정
    func sendData<T: Codable>(api: API, object: T) async throws {
        
        let baseComponent = api.urlComponets
        let httpMethod = api.httpMethod.rawValue
        guard let url = baseComponent?.url else { throw HTTPError.badURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue(MINEType.JSON.rawValue,
                         forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
        
        request.httpBody = try? JSONEncoder().encode(object)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HTTPError.badResponse
        }
        
        guard let object = try? JSONDecoder().decode(T.self, from: data) else {
            throw HTTPError.errorDecodingData
        }
    }
}
