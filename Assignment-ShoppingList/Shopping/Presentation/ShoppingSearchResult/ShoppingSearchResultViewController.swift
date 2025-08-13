//
//  ShoppingSearchResultViewController.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit

import SnapKit


final class ShoppingSearchResultViewController: UIViewController {
    
    private let viewModel: ShoppingSearchResultViewModel
    private let rootView = ShoppingSearchResultView()
    
    private var shoppingListCollectionView: UICollectionView { rootView.shoppingListCollectionView }
    private var recommendedItemsCollectionView: UICollectionView { rootView.recommendedItemsCollectionView }
    private var filteringBadges: UIStackView { rootView.filteringBadges }
    
    init(searchText: String) {
        // 일단 광고 키워드는 고정값으로..
        self.viewModel = ShoppingSearchResultViewModel(searchText: searchText, recommendedKeyword: "아이폰")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDelegates()
        setupActions()
        
        setupOutputActions()
    }
    
    private func setupCollectionView() {
        shoppingListCollectionView.register(
            ShoppingItemCell.self,
            forCellWithReuseIdentifier: ShoppingItemCell.reuseIdentifier
        )
        
        recommendedItemsCollectionView.register(
            RecommendedItemCell.self,
            forCellWithReuseIdentifier: RecommendedItemCell.reuseIdentifier
        )
    }
    
    private func setupDelegates() {
        shoppingListCollectionView.dataSource = self
        shoppingListCollectionView.delegate = self
        
        recommendedItemsCollectionView.dataSource = self
        recommendedItemsCollectionView.delegate = self
    }
    
    private func setupActions() {
        rootView.filteringBadges.arrangedSubviews.forEach { subView in
            if let filteringButton = subView as? ShoppingListFilteringButton {
                filteringButton.addTarget(self, action: #selector(handleFilteringBadgeTapped), for: .touchUpInside)
            }
        }
    }
    
    @objc private func handleFilteringBadgeTapped(_ sender: ShoppingListFilteringButton) {
        viewModel.input.filterButtonTapped.value = sender.sort
    }
    
    private func setupOutputActions() {
        let output = viewModel.output
        
        output.sortingCriterionChanged.subscribe { [weak self] criterion in
            // stackView 에 버튼들의 select 상태 반영
            self?.filteringBadges.arrangedSubviews.forEach { subView in
                if let filteringButton = subView as? ShoppingListFilteringButton {
                    filteringButton.isSelected = (filteringButton.sort == criterion)
                }
            }
            self?.rootView.setResultCountText(0)
        }
        
        output.shoppingListUpdated.subscribe { [weak self] resultType in
            switch resultType {
            case .appendNew:
                break
            case .reload(let totalResultCount):
                self?.rootView.setResultCountText(totalResultCount)
            }
            self?.shoppingListCollectionView.reloadData()
        }
        
        output.recommendedListUpdated.subscribe { [weak self] _ in
            self?.recommendedItemsCollectionView.reloadData()
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension ShoppingSearchResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == shoppingListCollectionView {
            return viewModel.shoppingListDataSource.count
        } else {
            return viewModel.recommendedItemDataSource.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if collectionView == shoppingListCollectionView {
            let item = viewModel.shoppingListDataSource[indexPath.item]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ShoppingItemCell.reuseIdentifier,
                for: indexPath
            ) as! ShoppingItemCell
            cell.configure(with: item)
            return cell
        } else {
            let item = viewModel.recommendedItemDataSource[indexPath.item]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedItemCell.reuseIdentifier,
                for: indexPath
            ) as! RecommendedItemCell
            cell.configure(with: item.image)
            return cell
        }
    }
    
}


// MARK: - UICollectionViewDelegate
extension ShoppingSearchResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == shoppingListCollectionView {
            viewModel.input.shoppingListWillDisplay.value = indexPath
        } else {
            viewModel.input.recommendedItemWillDisplay.value = indexPath
        }
    }
    
}


extension ShoppingSearchResultViewController {
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}
