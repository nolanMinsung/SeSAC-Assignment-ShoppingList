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
    private let itemCountPerPage: Int = 15 // 상황에 따라 런타임 시점에 page 단위를 변경한다면 변수로 선언할 수도 있음.
    // start에 들어갈 숫자는 1 + (numberOfInPage x 페이지 번호)
    // 페이지 번호는 0, 1, 2, ...
    private var page: Int = 0
    private var isEnd: Bool = false
    private var currentFilter: SortingCriterion = .sim
    private var isFetchingFromServer: Bool = false
    
    
    var shoppingListDataSource: [ShoppingItem] = []
    
    let rootView = ShoppingSearchResultView()
    var shoppingListCollectionView: UICollectionView { rootView.shoppingListCollectionView }
    var filteringBadges: UIStackView { rootView.filteringBadges }
    
    init(searchText: String) {
        self.searchText = searchText
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
        
        searchShoppingList(query: searchText, display: itemCountPerPage)
    }
    
    private func setupCollectionView() {
        shoppingListCollectionView.register(
            ShoppingItemCell.self,
            forCellWithReuseIdentifier: ShoppingItemCell.reuseIdentifier
        )
    }
    
    private func setupDelegates() {
        shoppingListCollectionView.dataSource = self
        shoppingListCollectionView.delegate = self
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
        page = 0
        isEnd = false
        searchShoppingList(query: searchText, display: itemCountPerPage, sort: currentFilter)
    }
    
}


// MARK: - 네트워크 통신
extension ShoppingSearchResultViewController {
    
    private func searchShoppingList(query: String, display: Int, sort: SortingCriterion = .sim) {
        isFetchingFromServer = true
        ShoppingListNetworkService.shared.fetchShoppingList(
            query: query,
            display: display,
            start: 1 + (itemCountPerPage * page),
            sort: sort
        ) { [weak self] result in
            switch result {
            case .success(let resultDTO):
                self?.handleFetchedDTO(resultDTO)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(message: error.localizedDescription)
            }
            self?.isFetchingFromServer = false
        }
    }
    
    private func handleFetchedDTO(_ dto: ShoppingSearchResultDTO) {
        if page == 0 {
            self.rootView.setResultCountText(dto.total)
        }
        do {
            let shoppingItemsDTO = dto.items
            let shoppingItems = try shoppingItemsDTO.map { try ShoppingItem.from(dto: $0) }
            self.shoppingListDataSource.append(contentsOf: shoppingItems)
            self.shoppingListCollectionView.reloadData()
            
            isEnd = shoppingListDataSource.count >= dto.total
            
            if page == 0 && shoppingListDataSource.count > 0 {
                shoppingListCollectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: false)
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
        return shoppingListDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = shoppingListDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ShoppingItemCell.reuseIdentifier,
            for: indexPath
        ) as! ShoppingItemCell
        cell.configure(with: item)
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate
extension ShoppingSearchResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.item == shoppingListDataSource.count - 4) && !isEnd && !isFetchingFromServer {
            page += 1
            searchShoppingList(query: searchText, display: 20, sort: currentFilter)
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
