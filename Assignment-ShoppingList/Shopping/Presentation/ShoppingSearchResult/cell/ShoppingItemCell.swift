//
//  ShoppingItemCell.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit

import Kingfisher
import SnapKit


final class ShoppingItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ShoppingItemCell.self)
    
    let imageView = UIImageView()
    let hearButton = UIButton(configuration: .filled())
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    lazy var stackView = UIStackView(
        arrangedSubviews: [
            mallNameLabel,
            titleLabel,
            priceLabel,
        ]
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDesign()
        setupViewHierarchy()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        mallNameLabel.text = ""
        titleLabel.text = ""
        priceLabel.text = ""
    }
    
    private func setupDesign() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        hearButton.configuration?.baseBackgroundColor = .white
        hearButton.configuration?.baseForegroundColor = .black
        hearButton.setImage(.init(systemName: "heart"), for: .normal)
        hearButton.setImage(.init(systemName: "heart.fill"), for: .selected)
        hearButton.layer.cornerRadius = 20
        hearButton.clipsToBounds = true
        
        mallNameLabel.font = .systemFont(ofSize: 11)
        mallNameLabel.textColor = .systemGray
        
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.numberOfLines = 0
        
        priceLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .fill
        stackView.distribution = .fill
    }
    
    private func setupViewHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(hearButton)
        contentView.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        hearButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView).inset(8)
            make.size.equalTo(40)
        }
        
        titleLabel.setContentCompressionResistancePriority(.init(749), for: .vertical)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(with item: ShoppingItem) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        imageView.kf.setImage(with: item.image)
        mallNameLabel.text = item.mallName
        titleLabel.text = item.title
        priceLabel.text = numberFormatter.string(from: item.lprice as NSNumber)
    }
    
}
