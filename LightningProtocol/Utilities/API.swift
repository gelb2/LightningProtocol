//
//  API.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation

enum GenderType: String {
    case male
    case female
}

enum API {
    
    case randomUser(userType)
    
    enum userType {
        case man(resultCount: Int, pageIndex: Int, gender: GenderType)
        case woman(resultCount: Int, pageIndex: Int, gender: GenderType)
    }
    
    var urlComponets: URLComponents? {
        switch self {
        case .randomUser:
            var baseURLSet = baseURLSet
            baseURLSet?.queryItems = getMethodQuerySet
            return baseURLSet
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .randomUser:
            return HTTPMethod.GET
        }
    }
    
    private var baseURLSet: URLComponents? {
        switch self {
        case .randomUser:
            return URLComponents(string: "https://randomuser.me/api/")
                                 
        }
    }

    // TODO: 쿼리 잘 넣는 방법 다시 생각좀...
    private var getMethodQuerySet: [URLQueryItem] {
        switch self {
        case .randomUser(.man(let resultCount, let pageIndex, let gender)):
            let resultCount = [URLQueryItem(name: "results", value: "\(resultCount)")]
            let pageIndex = [URLQueryItem(name: "page", value: "\(pageIndex)")]
            let gender = [URLQueryItem(name: "gender", value: gender.rawValue)]
            return resultCount + pageIndex + gender
        case .randomUser(.woman(let resultCount, let pageIndex, let gender)):
            let resultCount = [URLQueryItem(name: "results", value: "\(resultCount)")]
            let pageIndex = [URLQueryItem(name: "page", value: "\(pageIndex)")]
            let gender = [URLQueryItem(name: "gender", value: gender.rawValue)]
            return resultCount + pageIndex + gender
        
        }
    }
}
