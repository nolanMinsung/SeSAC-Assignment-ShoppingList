//
//  NaverOPENAPISearchRouter.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 8/13/25.
//

import Foundation

import Alamofire

// 각 case의 이름은 서버 API에서 요구하는 query 이름.
enum SortingCriterion: String, CaseIterable {
    /// 정확도순
    case sim
    /// 날짜순
    case date
    /// 가격낮은순
    case asc
    /// 가격높은순
    case dsc
}

enum NaverOPENAPISearchRouter {
    
    case shop(query: String, display: Int, start: Int, sort: SortingCriterion)
    
    var baseURL: String {
        return "https://openapi.naver.com/v1/"
    }
    
    var endpointString: String {
        switch self {
        case .shop:
            baseURL + "search/shop.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .shop:
            return .get
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .shop(let query, let display, let start, let sort):
            return [
                "query": query,
                "display": "\(display)",
                "start": "\(start)",
                "sort": sort.rawValue
            ]
        }
    }
    
    var headers: HTTPHeaders {
        get throws {
            switch self {
            case .shop:
                guard let infoDictionary = Bundle.main.infoDictionary else {
                    throw NetworkServiceError.infoPlistNotFound
                }
                guard let apiID = infoDictionary["NaverDevAPIID"] as? String else {
                    throw NetworkServiceError.apiIDNotFound(id: "NaverDevAPIID")
                }
                guard let apiKey = infoDictionary["NaverDevAPIKEy"] as? String else {
                    throw NetworkServiceError.apiKeyNotFound(key: "NaverDevAPIKEy")
                }
                return HTTPHeaders(["X-Naver-Client-Id": apiID, "X-Naver-Client-Secret": apiKey])
            }
        }
    }
    
}
