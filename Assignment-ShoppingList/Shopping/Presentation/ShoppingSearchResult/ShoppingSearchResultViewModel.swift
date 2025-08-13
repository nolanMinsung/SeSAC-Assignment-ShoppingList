//
//  ShoppingSearchResultViewModel.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 8/12/25.
//

import Foundation

enum SearchResultUpdateType {
    case appendNew
    case reload(totalResultCount: Int)
}

enum ErrorHandlingType {
    case alert(message: String)
}

final class ShoppingSearchResultViewModel {
    
    // MARK: - Input
    
    struct Input {
        let filterButtonTapped = MSSubject<SortingCriterion>(value: .sim)
        let shoppingListWillDisplay = MSSubject<IndexPath>(value: .init(item: 0, section: 0))
        let recommendedItemWillDisplay = MSSubject<IndexPath>(value: .init(item: 0, section: 0))
    }
    
    // MARK: - Output
    
    struct Output {
        let sortingCriterionChanged = MSSubject<SortingCriterion>(value: .sim)
        let shoppingListUpdated = MSSubject<SearchResultUpdateType>(value: .reload(totalResultCount: 0))
        let recommendedListUpdated = MSSubject<SearchResultUpdateType>(value: .reload(totalResultCount: 0))
        let searchingErrorOutput = MSSubject<ErrorHandlingType>(value: .alert(message: ""))
    }
    
    let input: Input
    let output: Output
    
    // MARK: - 데이터 상태 저장
    
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
    
    private(set) var shoppingListDataSource: [ShoppingItem] = []
    private(set) var recommendedItemDataSource: [ShoppingItem] = []
    
    init(searchText: String, recommendedKeyword: String) {
        self.input = Input()
        self.output = Output()
        
        self.searchText = searchText
        self.recommendedKeyword = recommendedKeyword
        
        input.filterButtonTapped.subscribe { [weak self] criterion in
            guard let self else { return }
            // 필터 기준이 기존과 달라지는 경우만
            guard criterion != currentFilter else { return }
            
            output.sortingCriterionChanged.value = criterion
            currentFilter = criterion
            shoppingListDataSource.removeAll(keepingCapacity: true)
            self.output.shoppingListUpdated.value = .reload(totalResultCount: 0)
            shoppingListPage = 0
            shoppingListIsEnd = false
            searchShoppingList(query: searchText, display: shoppingListItemCountPerPage, sort: criterion)
        }
        
        input.shoppingListWillDisplay.subscribe { [weak self] indexPath in
            guard let self else { return }
            
            if (indexPath.item == self.shoppingListDataSource.count - 4) && !self.shoppingListIsEnd && !self.shoppingListIsFetching {
                self.shoppingListPage += 1
                self.searchShoppingList(query: self.searchText, display: 20, sort: self.currentFilter)
            }
        }
        
        input.recommendedItemWillDisplay.subscribe { [weak self] indexPath in
            guard let self else { return }
            
            if (indexPath.item == self.recommendedItemDataSource.count - 4) && !self.recommendedItemListIsEnd && !self.recommendedItemListIsFetching {
                self.recommendedItemPage += 1
                self.fetchRecommendedItems(display: 20)
            }
        }
        
        // 구독 설정 후 첫 번째 서버 데이터 요청
        searchShoppingList(query: searchText, display: shoppingListItemCountPerPage)
        fetchRecommendedItems(display: 20)
    }
    
}


extension ShoppingSearchResultViewModel {
    
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
                self?.output.searchingErrorOutput.value = .alert(message: error.localizedDescription)
            }
            self?.shoppingListIsFetching = false
        }
    }
    
    private func fetchRecommendedItems(display: Int) {
        recommendedItemListIsFetching = true
        ShoppingListNetworkService.shared.fetchShoppingList(
            query: self.recommendedKeyword,
            display: display,
            start: 1,
            sort: SortingCriterion.sim
        ) { [weak self] result in
            switch result {
            case .success(let resultDTO):
                self?.handleFetchRecommendedDTO(resultDTO)
            case .failure(let error):
                print(error.localizedDescription)
                self?.output.searchingErrorOutput.value = .alert(message: error.localizedDescription)
            }
            self?.recommendedItemListIsFetching = false
        }
    }
    
    private func handleFetchedDTO(_ dto: ShoppingSearchResultDTO) {
        do {
            let shoppingItemsDTO = dto.items
            let shoppingItems = try shoppingItemsDTO.map { try ShoppingItem.from(dto: $0) }
            self.shoppingListDataSource.append(contentsOf: shoppingItems)
            
            shoppingListIsEnd = shoppingListDataSource.count >= dto.total
            
            if shoppingListPage == 0 && shoppingListDataSource.count > 0 {
                output.shoppingListUpdated.value = .reload(totalResultCount: dto.total)
            } else {
                output.shoppingListUpdated.value = .appendNew
            }
            
        } catch {
            print(error.localizedDescription)
            self.output.searchingErrorOutput.value = .alert(message: error.localizedDescription)
        }
    }
    
    private func handleFetchRecommendedDTO(_ dto: ShoppingSearchResultDTO) {
        do {
            let recommendedItemsDTO = dto.items
            let recommendedItems = try recommendedItemsDTO.map { try ShoppingItem.from(dto: $0) }
            self.recommendedItemDataSource.append(contentsOf: recommendedItems)
            
            recommendedItemListIsEnd = recommendedItemDataSource.count >= dto.total
            
            if recommendedItemPage == 0 && recommendedItemDataSource.count > 0 {
                self.output.recommendedListUpdated.value = .reload(totalResultCount: dto.total)
            } else {
                self.output.recommendedListUpdated.value = .appendNew
            }
        } catch {
            print(error.localizedDescription)
            self.output.searchingErrorOutput.value = .alert(message: error.localizedDescription)
        }
    }
    
}
