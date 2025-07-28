//
//  ShoppingMainViewController.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit

import SnapKit


final class ShoppingMainViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "영캠러의 쇼핑쇼핑"
        view.backgroundColor = .systemBackground
        
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.delegate = self
    }
    
}


extension ShoppingMainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let trimmedText = searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let shoppingSearchResultVC = ShoppingSearchResultViewController(searchText: trimmedText)
        navigationController?.pushViewController(shoppingSearchResultVC, animated: true)
    }
    
}
