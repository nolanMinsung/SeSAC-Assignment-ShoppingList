//
//  ShoppingItem.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import Foundation

struct ShoppingItem {
    
    static func from(dto: ShoppingItemDTO) throws -> ShoppingItem {
        let imageURL = URL(string: dto.image)
        if imageURL == nil {
            print("shoppingItem의 imageURL이 형식에 맞지 않습니다.")
        }
        return ShoppingItem(
            title: dto.title.readHTML,
            htmlTitle: dto.title.readHTMLToAttributed,
            image: imageURL,
            lprice: Int(dto.lprice)!,
            mallName: dto.mallName,
            productId: Int(dto.productId)!
        )
    }
    
    init(
        title: String,
        htmlTitle: NSAttributedString,
        image: URL?,
        lprice: Int,
        mallName: String,
        productId: Int
    ) {
        self.title = title.readHTML
        self.htmlTitle = htmlTitle
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.productId = productId
    }
    
    init(
        title: String,
        image: URL?,
        lprice: Int,
        mallName: String,
        productId: Int
    ) {
        self.title = title.readHTML
        self.htmlTitle = title.readHTMLToAttributed
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.productId = productId
    }
    
    let title: String
    let htmlTitle: NSAttributedString
//    let link: URL
    let image: URL?
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
