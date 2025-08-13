//
//  NetworkServiceError.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 8/13/25.
//

import Foundation

enum NetworkServiceError: LocalizedError {
    
    case infoPlistNotFound
    case apiIDNotFound(id: String)
    case apiKeyNotFound(key: String)
    case invalidEndpoint(String)
    case responseValueNotFound
    
    var errorDescription: String? {
        switch self {
        case .infoPlistNotFound:
            "info.plist 찾을 수 없음."
        case .apiIDNotFound(let idName):
            "info.plist에서 api id를 찾을 수 없음. id name: \(idName)"
        case .apiKeyNotFound(let keyName):
            "info.plist에서 api key를 찾을 수 없음. key name: \(keyName)"
        case .invalidEndpoint(let urlString):
            "유효한 형식의 Endpoint가 아님: \(urlString)"
        case .responseValueNotFound:
            "데이터 통신에는 성공했으나, 값이 비어있음."
        }
    }
    
}
