//
//  ShoppingSearchResultViewController.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit

import SnapKit


final class ShoppingSearchResultViewController: UIViewController {
    
    private let searchText: String
    private let shoppingListItemCountPerPage: Int = 15 // 상황에 따라 런타임 시점에 page 단위를 변경한다면 변수로 선언할 수도 있음.
    // start에 들어갈 숫자는 1 + (shoppingListItemCountPerPage x 페이지 번호)
    // 페이지 번호는 0, 1, 2, ...
    private var shoppingListPage: Int = 0
    private var shoppingListIsEnd: Bool = false
    private var currentFilter: SortingCriterion = .sim
    private var shoppingListIsFetching: Bool = false
    
    // 추천 아이템들
    
    private let recommendedKeyword: String
    private let recommendedItemCountPerPage: Int = 15 // 상황에 따라 런타임 시점에 page 단위를 변경한다면 변수로 선언할 수도 있음.
    // start에 들어갈 숫자는 1 + (numberOfInPage x 페이지 번호)
    // 페이지 번호는 0, 1, 2, ...
    private var recommendedItemPage: Int = 0
    private var recommendedItemListIsEnd: Bool = false
    private var recommendedItemListIsFetching: Bool = false
    
    
    var shoppingListDataSource: [ShoppingItem] = []
    var recommendedItemDataSource: [ShoppingItem] = []
    
    let rootView = ShoppingSearchResultView()
    var shoppingListCollectionView: UICollectionView { rootView.shoppingListCollectionView }
    var recommendedItemsCollectionView: UICollectionView { rootView.recommendedItemsCollectionView }
    var filteringBadges: UIStackView { rootView.filteringBadges }
    
    init(searchText: String) {
        self.searchText = searchText
        self.recommendedKeyword = "아이폰" // 일단 광고 키워드는 고정값으로..
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
        
        searchShoppingList(query: searchText, display: shoppingListItemCountPerPage)
        fetchRecommendedItems()
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
        filteringBadges.arrangedSubviews.forEach { subView in
            if let filteringButton = subView as? ShoppingListFilteringButton {
                filteringButton.addTarget(self, action: #selector(handleFilteringBadgeTapped), for: .touchUpInside)
            }
        }
    }
    
    @objc private func handleFilteringBadgeTapped(_ sender: ShoppingListFilteringButton) {
        // 필터 기준이 달라지는 경우만 서버에 재요청
        guard sender.sort != currentFilter else { return }
        
        // stackView 에 버튼들의 select 상태 반영
        filteringBadges.arrangedSubviews.forEach { subView in
            if let filteringButton = subView as? ShoppingListFilteringButton {
                filteringButton.isSelected = (filteringButton === sender)
            }
        }
        currentFilter = sender.sort
        shoppingListDataSource.removeAll()
        rootView.setResultCountText(0)
        shoppingListPage = 0
        shoppingListIsEnd = false
        searchShoppingList(query: searchText, display: shoppingListItemCountPerPage, sort: currentFilter)
    }
    
}


// MARK: - 네트워크 통신
extension ShoppingSearchResultViewController {
    
    private func searchShoppingList(query: String, display: Int, sort: SortingCriterion = .sim) {
        shoppingListIsFetching = true
        ShoppingListNetworkService.shared.fetchShoppingList(
            query: query,
            display: display,
            start: 1 + (shoppingListItemCountPerPage * shoppingListPage),
            sort: sort
        ) { [weak self] result in
            switch result {
            case .success(let resultDTO):
                self?.handleFetchedDTO(resultDTO)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(message: error.localizedDescription)
            }
            self?.shoppingListIsFetching = false
        }
    }
    
    private func fetchRecommendedItems() {
        recommendedItemListIsFetching = true
        ShoppingListNetworkService.shared.fetchShoppingList(
            query: self.recommendedKeyword,
            display: 20,
            start: 1,
            sort: SortingCriterion.sim
        ) { [weak self] result in
            switch result {
            case .success(let resultDTO):
                self?.handleFetchRecommendedDTO(resultDTO)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(message: error.localizedDescription)
            }
            self?.recommendedItemListIsFetching = false
        }
    }
    
    private func handleFetchedDTO(_ dto: ShoppingSearchResultDTO) {
        if shoppingListPage == 0 {
            self.rootView.setResultCountText(dto.total)
        }
        do {
            let shoppingItemsDTO = dto.items
            let shoppingItems = try shoppingItemsDTO.map { try ShoppingItem.from(dto: $0) }
            self.shoppingListDataSource.append(contentsOf: shoppingItems)
            self.shoppingListCollectionView.reloadData()
            
            shoppingListIsEnd = shoppingListDataSource.count >= dto.total
            
            if shoppingListPage == 0 && shoppingListDataSource.count > 0 {
                shoppingListCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: false)
            }
            
        } catch {
            print(error.localizedDescription)
            self.showAlert(message: error.localizedDescription)
        }
    }
    
    private func handleFetchRecommendedDTO(_ dto: ShoppingSearchResultDTO) {
        do {
            let recommendedItemsDTO = dto.items
            let recommendedItems = try recommendedItemsDTO.map { try ShoppingItem.from(dto: $0) }
            self.recommendedItemDataSource.append(contentsOf: recommendedItems)
            self.recommendedItemsCollectionView.reloadData()
            
            recommendedItemListIsEnd = recommendedItemDataSource.count >= dto.total
            
            if recommendedItemPage == 0 && recommendedItemDataSource.count > 0 {
                recommendedItemsCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: false)
            }
            
        } catch {
            print(error.localizedDescription)
            self.showAlert(message: error.localizedDescription)
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension ShoppingSearchResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == shoppingListCollectionView {
            return shoppingListDataSource.count
        } else {
            return recommendedItemDataSource.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if collectionView == shoppingListCollectionView {
            let item = shoppingListDataSource[indexPath.item]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ShoppingItemCell.reuseIdentifier,
                for: indexPath
            ) as! ShoppingItemCell
            cell.configure(with: item)
            return cell
        } else {
            let item = recommendedItemDataSource[indexPath.item]
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
            if (indexPath.item == shoppingListDataSource.count - 4) && !shoppingListIsEnd && !shoppingListIsFetching {
                shoppingListPage += 1
                searchShoppingList(query: searchText, display: 20, sort: currentFilter)
            }
        } else {
            if (indexPath.item == recommendedItemDataSource.count - 4) && !recommendedItemListIsEnd && !recommendedItemListIsFetching {
                recommendedItemPage += 1
                fetchRecommendedItems()
            }
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
