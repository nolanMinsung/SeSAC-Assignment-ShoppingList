//
//  ShoppingSearchResultViewController.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit

import SnapKit

final class ShoppingSearchResultViewController: UIViewController {
    
//    let dummyShoppingList: [ShoppingItem] = [
//        .init(
//            title: "친한사이<b>캠핑카</b> Whale560L 풀옵션 <b>캠핑카</b> 모터홈 포터<b>캠핑카</b> 봉고<b>캠핑카</b>",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8685624/86856240547.1.jpg"),
//            lprice: 79200000,
//            mallName: "친한사이 캠핑카",
//            productId: 86856240547
//        ),
//        .init(
//            title: "[SUV <b>캠핑카</b>] 컴팩트, 소형, 준중형 2인승 2인취침 <b>캠핑카</b> 구조변경 (침상, 테이블)",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8884653/88846533057.1.jpg"),
//            lprice: 1925000,
//            mallName: "잼 캠핑카",
//            productId: 88846533057
//        ),
//        .init(
//            title: "<b>캠핑카</b> 카라반 툴레 피아마 어닝메쉬룸 주니스 어닝용모기장 구형295",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_1145428/11454289647.3.jpg"),
//            lprice: 169000,
//            mallName: "JUNIS Caravan",
//            productId: 11454289647
//        ),
//        .init(
//            title: "친한사이<b>캠핑카</b> Whale560L 풀옵션 <b>캠핑카</b> 모터홈 포터<b>캠핑카</b> 봉고<b>캠핑카</b>",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8685624/86856240547.1.jpg"),
//            lprice: 79200000,
//            mallName: "친한사이 캠핑카",
//            productId: 86856240547
//        ),
//        .init(
//            title: "[SUV <b>캠핑카</b>] 컴팩트, 소형, 준중형 2인승 2인취침 <b>캠핑카</b> 구조변경 (침상, 테이블)",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8884653/88846533057.1.jpg"),
//            lprice: 1925000,
//            mallName: "잼 캠핑카",
//            productId: 88846533057
//        ),
//        .init(
//            title: "<b>캠핑카</b> 카라반 툴레 피아마 어닝메쉬룸 주니스 어닝용모기장 구형295",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_1145428/11454289647.3.jpg"),
//            lprice: 169000,
//            mallName: "JUNIS Caravan",
//            productId: 11454289647
//        ),
//        .init(
//            title: "친한사이<b>캠핑카</b> Whale560L 풀옵션 <b>캠핑카</b> 모터홈 포터<b>캠핑카</b> 봉고<b>캠핑카</b>",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8685624/86856240547.1.jpg"),
//            lprice: 79200000,
//            mallName: "친한사이 캠핑카",
//            productId: 86856240547
//        ),
//        .init(
//            title: "[SUV <b>캠핑카</b>] 컴팩트, 소형, 준중형 2인승 2인취침 <b>캠핑카</b> 구조변경 (침상, 테이블)",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8884653/88846533057.1.jpg"),
//            lprice: 1925000,
//            mallName: "잼 캠핑카",
//            productId: 88846533057
//        ),
//        .init(
//            title: "<b>캠핑카</b> 카라반 툴레 피아마 어닝메쉬룸 주니스 어닝용모기장 구형295",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_1145428/11454289647.3.jpg"),
//            lprice: 169000,
//            mallName: "JUNIS Caravan",
//            productId: 11454289647
//        ),
//        .init(
//            title: "친한사이<b>캠핑카</b> Whale560L 풀옵션 <b>캠핑카</b> 모터홈 포터<b>캠핑카</b> 봉고<b>캠핑카</b>",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8685624/86856240547.1.jpg"),
//            lprice: 79200000,
//            mallName: "친한사이 캠핑카",
//            productId: 86856240547
//        ),
//        .init(
//            title: "[SUV <b>캠핑카</b>] 컴팩트, 소형, 준중형 2인승 2인취침 <b>캠핑카</b> 구조변경 (침상, 테이블)",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8884653/88846533057.1.jpg"),
//            lprice: 1925000,
//            mallName: "잼 캠핑카",
//            productId: 88846533057
//        ),
//        .init(
//            title: "<b>캠핑카</b> 카라반 툴레 피아마 어닝메쉬룸 주니스 어닝용모기장 구형295",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_1145428/11454289647.3.jpg"),
//            lprice: 169000,
//            mallName: "JUNIS Caravan",
//            productId: 11454289647
//        ),
//        .init(
//            title: "친한사이<b>캠핑카</b> Whale560L 풀옵션 <b>캠핑카</b> 모터홈 포터<b>캠핑카</b> 봉고<b>캠핑카</b>",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8685624/86856240547.1.jpg"),
//            lprice: 79200000,
//            mallName: "친한사이 캠핑카",
//            productId: 86856240547
//        ),
//        .init(
//            title: "[SUV <b>캠핑카</b>] 컴팩트, 소형, 준중형 2인승 2인취침 <b>캠핑카</b> 구조변경 (침상, 테이블)",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_8884653/88846533057.1.jpg"),
//            lprice: 1925000,
//            mallName: "잼 캠핑카",
//            productId: 88846533057
//        ),
//        .init(
//            title: "<b>캠핑카</b> 카라반 툴레 피아마 어닝메쉬룸 주니스 어닝용모기장 구형295",
//            image: .init(string: "https://shopping-phinf.pstatic.net/main_1145428/11454289647.3.jpg"),
//            lprice: 169000,
//            mallName: "JUNIS Caravan",
//            productId: 11454289647
//        ),
//    ]
    var shoppingListDataSource: [ShoppingItem] = []
    
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
        setupCollectionView()
        setupDelegates()
        setupActions()
        
        searchShoppingList(query: "모기장")
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
    
    @objc private func handleFilteringBadgeTapped(_ sender: UIButton) {
        filteringBadges.arrangedSubviews.forEach { subView in
            if let filteringButton = subView as? ShoppingListFilteringButton {
                filteringButton.isSelected = (filteringButton === sender)
            }
        }
    }
    
    private func searchShoppingList(query: String, display: Int = 20) {
        ShoppingListNetworkService.shared.fetchShoppingList(
            query: query,
            display: display
        ) { [weak self] result in
            switch result {
            case .success(let resultDTO):
                self?.resultCountLabel.text = "\(resultDTO.total.formatted())개의 검색 결과"
                do {
                    let shoppingItemsDTO = resultDTO.items
                    let shoppingItems = try shoppingItemsDTO.map { try ShoppingItem.from(dto: $0) }
                    self?.shoppingListDataSource = shoppingItems
                    self?.shoppingListCollectionView.reloadData()
                } catch {
                    print(error.localizedDescription)
                    self?.showAlert(message: error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
}


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

extension ShoppingSearchResultViewController: UICollectionViewDelegate {
    
}


extension ShoppingSearchResultViewController {
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}
