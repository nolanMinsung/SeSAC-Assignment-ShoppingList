//
//  ShoppingSearchResultDTO.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import Foundation


struct ShoppingSearchResultDTO: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [ShoppingItemDTO]
}

struct ShoppingItemDTO: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: Int
    let hprice: Int
    let mallName: String
    let productId: Int
    let productType: Int
    let brand: String
    let maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
    
}
