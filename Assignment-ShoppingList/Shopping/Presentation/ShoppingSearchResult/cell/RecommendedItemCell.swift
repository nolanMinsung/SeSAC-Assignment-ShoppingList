//
//  RecommendedItemCell.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/29/25.
//

import UIKit

import Kingfisher
import SnapKit


final class RecommendedItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: RecommendedItemCell.self)
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    func configure(with url: URL?) {
        imageView.kf.setImage(with: url)
    }
    
}
