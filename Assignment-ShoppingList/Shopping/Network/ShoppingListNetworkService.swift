//
//  ShoppingListNetworkService.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/28/25.
//

import Foundation

import Alamofire

final class ShoppingListNetworkService {
    
    static let shared = ShoppingListNetworkService()
    private init() { }
    
    func searchShopping<T: Decodable>(
        apiRouter: NaverOPENAPISearchRouter,
        type: T.Type,
        completion: @escaping (Result<T, any Error>) -> Void
    ) {
        guard let url = URL(string: apiRouter.endpointString) else {
            completion(.failure(NetworkServiceError.invalidEndpoint(apiRouter.endpointString)))
            return
        }
        
        do {
            let headers = try apiRouter.headers
            AF.request(
                url,
                method: apiRouter.method,
                parameters: apiRouter.parameter,
                headers: headers
            ).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let resultDTO):
                    completion(.success(resultDTO))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // Swift Concurrency 방식으로도 구현해보았음. (아직 적용하진 않음.)
    func searchShohpping<T: Decodable>(apiRouter: NaverOPENAPISearchRouter, type: T.Type) async throws -> T {
        guard let url = URL(string: apiRouter.endpointString) else {
            throw NetworkServiceError.invalidEndpoint(apiRouter.endpointString)
        }
        let headers = try apiRouter.headers
        let request = AF.request(url, method: apiRouter.method, parameters: apiRouter.parameter, headers: headers)
        let resultValue = try await request.serializingDecodable(T.self).value
        return resultValue
    }
    
}
