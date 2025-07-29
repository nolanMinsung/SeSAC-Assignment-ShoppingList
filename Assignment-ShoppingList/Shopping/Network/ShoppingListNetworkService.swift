//
//  ShoppingListNetworkService.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/28/25.
//

import Foundation

import Alamofire

enum NetworkServiceError: LocalizedError {
    case infoPlistNotFound
    case apiIDNotFound(id: String)
    case apiKeyNotFound(key: String)
    case responseValueNotFound
    
    var errorDescription: String? {
        switch self {
        case .infoPlistNotFound:
            "info.plist 찾을 수 없음."
        case .apiIDNotFound(let idName):
            "info.plist에서 api id를 찾을 수 없음. id name: \(idName)"
        case .apiKeyNotFound(let keyName):
            "info.plist에서 api key를 찾을 수 없음. key name: \(keyName)"
        case .responseValueNotFound:
            "데이터 통신에는 성공했으나, 값이 비어있음."
        }
    }
}

// 처음에는 버튼에 보일 텍스트("정확도", "가격높은순" 등...) 를 rawValue로 하려고 했으나,
// raw value는 서버 API의 query에 해당하는 값으로 구현.
// -> 버튼에 보일 텍스트는 localizing 등에 따라 동적으로 변할 수 있기 때문...
enum SortingCriterion: String, CaseIterable {
    case sim
    case date
    case asc
    case dsc
}

final class ShoppingListNetworkService {
    
    static let shared = try! ShoppingListNetworkService()
    
    let apiID: String
    let apiKey: String
    
    private init() throws {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            throw NetworkServiceError.infoPlistNotFound
        }
        
        guard let apiID = infoDictionary["NaverDevAPIID"] as? String else {
            throw NetworkServiceError.apiIDNotFound(id: "NaverDevAPIID")
        }
        self.apiID = apiID
        
        guard let apiKey = infoDictionary["NaverDevAPIKEy"] as? String else {
            throw NetworkServiceError.apiKeyNotFound(key: "NaverDevAPIKEy")
        }
        self.apiKey = apiKey
    }
    
    
    func fetchShoppingList(
        query: String,
        display: Int,
        start: Int,
        sort: SortingCriterion,
        completion: @escaping (Result<ShoppingSearchResultDTO, any Error>) -> Void
    ) {
        let baseUrlString = "https://openapi.naver.com/v1/search/shop.json"
        let parameters: [String: Any] = [
            "query": query,
            "display": "\(display)",
            "start": "\(start)",
            "sort": sort.rawValue
        ]
        let headers = HTTPHeaders(["X-Naver-Client-Id": apiID, "X-Naver-Client-Secret": apiKey])
        
        AF.request(
            baseUrlString,
            method: .get,
            parameters: parameters,
            headers: headers
        ).responseDecodable(of: ShoppingSearchResultDTO.self) { response in
            switch response.result {
            case .success(let resultDTO):
                completion(.success(resultDTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
//    func fetchRecommendedItems(
//        query: String,
//        completion: @escaping (Result<ShoppingSearchResultDTO, any Error>) -> Void
//    ) {
//        let baseUrlString = "https://openapi.naver.com/v1/search/shop.json"
//        let parameters: [String: Any] = [
//            "query": query,
//            "display": 20,
//            "start": 1,
//            "sort": SortingCriterion.sim.rawValue
//        ]
//        let headers = HTTPHeaders(["X-Naver-Client-Id": apiID, "X-Naver-Client-Secret": apiKey])
//        
//        AF.request(
//            baseUrlString,
//            method: .get,
//            parameters: parameters,
//            headers: headers
//        ).responseDecodable(of: ShoppingSearchResultDTO.self) { response in
//            switch response.result {
//            case .success(let resultDTO):
//                completion(.success(resultDTO))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
}
