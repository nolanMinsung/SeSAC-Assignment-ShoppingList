//
//  ShoppingItem.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import Foundation

enum ShoppingItemError: LocalizedError {
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "제품 이미지 URL 형식이 올바르지 않습니다."
        }
    }
}

struct ShoppingItem {
    
    static func from(dto: ShoppingItemDTO) throws -> ShoppingItem {
        guard let imageURL = URL(string: dto.image) else {
            throw ShoppingItemError.invalidURL
        }
        return ShoppingItem(
            title: dto.title,
            image: imageURL,
            lprice: dto.lprice,
            mallName: dto.mallName,
            productId: dto.productId
        )
    }
    
    let title: String
//    let link: URL
    let image: URL
    let lprice: Int
//    let hprice: Int
    let mallName: String
    let productId: Int
//    let productType: Int
//    let brand: String
//    let maker: String
//    let category1: String
//    let category2: String
//    let category3: String
//    let category4: String
    
}
