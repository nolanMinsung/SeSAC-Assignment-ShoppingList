//
//  ViewController.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
    
    let shoppingButton = UIButton(configuration: .tinted())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design
        view.backgroundColor = .systemBackground
        shoppingButton.tintColor = .label
        shoppingButton.configuration?.title = "쇼핑하구팡"
        shoppingButton.configuration?.image = UIImage(systemName: "cart.badge.plus")
        shoppingButton.configuration?.imagePadding = 10
        shoppingButton.configuration?.contentInsets = .init(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        
        // View Hierarchy
        view.addSubview(shoppingButton)
        
        // Layout Constraints
        shoppingButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Actions
        shoppingButton.addTarget(self, action: #selector(shoppingButtonTapped), for: .touchUpInside)
    }
    
    @objc private func shoppingButtonTapped(_ sender: UIButton) {
        navigationController?.pushViewController(ShoppingMainViewController(), animated: true)
    }
    
}

