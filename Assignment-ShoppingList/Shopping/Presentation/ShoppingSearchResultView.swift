//
//  ShoppingSearchResultView.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/29/25.
//

import UIKit


final class ShoppingSearchResultView: UIView {
    
    private let resultCountLabel = UILabel()
    private let filteringBadgesScrollView = UIScrollView()
    let filteringBadges = UIStackView()
    private(set) var shoppingListCollectionView: UICollectionView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionViewLayout()
        setupDesign()
        setupViewHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//프로그래밍 스위프트 도구
// Initial Settings
private extension ShoppingSearchResultView {
    
    func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            flowLayout.itemSize = CGSize(width: floor((UIScreen.main.bounds.width - 40)/2), height: 300)
        } else {
            flowLayout.itemSize = .init(width: 180, height: 300)
        }
        shoppingListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }
    
    func setupDesign() {
        backgroundColor = .systemBackground
        
        resultCountLabel.textColor = .systemGreen
        resultCountLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        resultCountLabel.text = "0개의 검색 결과"
        
        filteringBadges.axis = .horizontal
        filteringBadges.spacing = 10
        filteringBadges.alignment = .fill
        filteringBadges.distribution = .fill
        // 필터링 버튼들 추가
        SortingCriterion.allCases
            .map { ShoppingListFilteringButton(sort: $0) }
            .forEach { filteringBadges.addArrangedSubview($0) }
        
        guard let filteringButton = filteringBadges.arrangedSubviews[0] as? ShoppingListFilteringButton else {
            return
        }
        filteringButton.isSelected = true
    }
    
    func setupViewHierarchy() {
        addSubview(resultCountLabel)
        addSubview(filteringBadgesScrollView)
        filteringBadgesScrollView.addSubview(filteringBadges)
        addSubview(shoppingListCollectionView)
    }
    
    func setupLayout() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        filteringBadgesScrollView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        
        filteringBadges.snp.makeConstraints { make in
            make.verticalEdges.equalTo(filteringBadgesScrollView.frameLayoutGuide)
            make.horizontalEdges.equalTo(filteringBadgesScrollView.contentLayoutGuide)
        }
        
        shoppingListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filteringBadges.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
}



extension ShoppingSearchResultView {
    
    func setResultCountText(_ count: Int) {
        resultCountLabel.text = count.formatted() + "개의 검색 결과"
    }
    
}
