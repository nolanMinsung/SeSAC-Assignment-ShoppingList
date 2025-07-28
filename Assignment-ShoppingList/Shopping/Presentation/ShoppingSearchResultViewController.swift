//
//  ShoppingSearchResultViewController.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit

import SnapKit

enum FilterCriterion: String, CaseIterable {
    case accuracy = "정확도"
    case date = "날짜순"
    case priceAscending = "가격높은순"
    case priceDescending = "가격낮은순"
}

final class ShoppingSearchResultViewController: UIViewController {
    
    let searchText: String
    let numberOfInPage: Int = 20 // 상황에 따라 page 단위를 변경한다면 변수로 선언할 수도 있음.
    // start에 들어갈 숫자는 1 + (numberOfInPage x 페이지 번호)
    // 페이지 번호는 0, 1, 2, ...
    var page: Int = 0
    var isEnd: Bool = false
    var currentFilter: Sort = .sim
    var isFetchingFromServer: Bool = false
    
    
    var shoppingListDataSource: [ShoppingItem] = []
    
    private let resultCountLabel = UILabel()
    private let filteringBadgesScrollView = UIScrollView()
    private let filteringBadges = UIStackView()
    private var shoppingListCollectionView: UICollectionView!
    
    init(searchText: String) {
        self.searchText = searchText
        super.init(nibName: nil, bundle: nil)
        
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
        setupCollectionView()
        setupDelegates()
        setupActions()
        
        searchShoppingList(query: searchText, display: numberOfInPage)
    }
    
    private func setupCollectionViewLayout() {
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
    
    private func setupDesign() {
        view.backgroundColor = .systemBackground
        
        resultCountLabel.textColor = .systemGreen
        resultCountLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        resultCountLabel.text = "0개의 검색 결과"
        
        filteringBadges.axis = .horizontal
        filteringBadges.spacing = 10
        filteringBadges.alignment = .fill
        filteringBadges.distribution = .fill
        // 필터링 버튼들 추가
        Sort.allCases
            .map { ShoppingListFilteringButton(sort: $0) }
            .forEach { filteringBadges.addArrangedSubview($0) }
        
        guard let filteringButton = filteringBadges.arrangedSubviews[0] as? ShoppingListFilteringButton else {
            return
        }
        filteringButton.isSelected = true
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
        // stackView 에 버튼들의 select 상태 반영
        filteringBadges.arrangedSubviews.forEach { subView in
            if let filteringButton = subView as? ShoppingListFilteringButton {
                filteringButton.isSelected = (filteringButton === sender)
            }
        }
    }
    
}


// MARK: - 네트워크 통신
extension ShoppingSearchResultViewController {
    
    private func searchShoppingList(query: String, display: Int, sort: Sort = .sim) {
        isFetchingFromServer = true
        ShoppingListNetworkService.shared.fetchShoppingList(
            query: query,
            display: display,
            start: 1 + (numberOfInPage * page),
            sort: sort
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let resultDTO):
                if page == 0 {
                    self.resultCountLabel.text = "\(resultDTO.total.formatted())개의 검색 결과"
                }
                do {
                    let shoppingItemsDTO = resultDTO.items
                    let shoppingItems = try shoppingItemsDTO.map { try ShoppingItem.from(dto: $0) }
                    self.shoppingListDataSource.append(contentsOf: shoppingItems)
                    self.shoppingListCollectionView.reloadData()
                    
                    isEnd = shoppingListDataSource.count >= resultDTO.total
                    
                } catch {
                    print(error.localizedDescription)
                    self.showAlert(message: error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert(message: error.localizedDescription)
            }
            isFetchingFromServer = false
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
