//
//  ShoppingSearchResultViewController.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit

import SnapKit

final class ShoppingSearchResultViewController: UIViewController {
    
    enum FilterCriterion: String, CaseIterable {
        case accuracy = "정확도"
        case date = "날짜순"
        case priceAscending = "가격높은순"
        case priceDescending = "가격낮은순"
    }
    
    private let resultCountLabel = UILabel()
    private let filteringBadgesScrollView = UIScrollView()
    private let filteringBadges = UIStackView()
    private var shoppingListCollectionView: UICollectionView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewLayout()
        setupDesign()
        setupViewHierarchy()
        setupLayout()
        setupActions()
    }
    
    private func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: view.bounds.width - 10, height: 100)
        shoppingListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        shoppingListCollectionView.backgroundColor = .systemBlue
    }
    
    private func setupDesign() {
        view.backgroundColor = .systemBackground
        
        resultCountLabel.textColor = .systemGreen
        resultCountLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        resultCountLabel.text = "13,235449개의 검색 결과"
        
        filteringBadges.axis = .horizontal
        filteringBadges.spacing = 10
        filteringBadges.alignment = .fill
        filteringBadges.distribution = .fill
        // 필터링 버튼들 추가
        FilterCriterion.allCases
            .map { $0.rawValue }
            .map { ShoppingListFilteringButton(title: $0) }
            .forEach { filteringBadges.addArrangedSubview($0) }
    }
    
    private func setupViewHierarchy() {
        view.addSubview(resultCountLabel)
        view.addSubview(filteringBadgesScrollView)
        filteringBadgesScrollView.addSubview(filteringBadges)
        view.addSubview(shoppingListCollectionView)
    }
    
    private func setupLayout() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        filteringBadgesScrollView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        
        filteringBadges.snp.makeConstraints { make in
            make.verticalEdges.equalTo(filteringBadgesScrollView.frameLayoutGuide)
            make.horizontalEdges.equalTo(filteringBadgesScrollView.contentLayoutGuide)
        }
        
        shoppingListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filteringBadges.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupActions() {
        filteringBadges.arrangedSubviews.forEach { subView in
            if let filteringButton = subView as? ShoppingListFilteringButton {
                filteringButton.addTarget(self, action: #selector(handleFilteringBadgeTapped), for: .touchUpInside)
            }
        }
    }
    
    @objc private func handleFilteringBadgeTapped(_ sender: UIButton) {
        filteringBadges.arrangedSubviews.forEach { subView in
            if let filteringButton = subView as? ShoppingListFilteringButton {
                filteringButton.isSelected = (filteringButton === sender)
            }
        }
    }
    
}
