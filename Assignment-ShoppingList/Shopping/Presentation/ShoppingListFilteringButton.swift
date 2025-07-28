//
//  ShoppingListFilteringButton.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit


final class ShoppingListFilteringButton: UIButton {
    
    var sort: Sort
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .label : .clear
        }
    }
    
    init(sort: Sort) {
        self.sort = sort
        super.init(frame: .zero)
        let title: String
        switch sort {
        case .sim: title = "정확도"
        case .date: title = "날짜순"
        case .asc: title = "가격높은순"
        case .dsc: title = "가격낮은순"
        }
        self.setTitle("  \(title)  ", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 15)
        self.setTitleColor(.label, for: .normal)
        self.setTitleColor(.systemBackground, for: .selected)
        self.traitCollection.performAsCurrent {
            self.layer.borderColor = UIColor.label.cgColor
        }
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 7
        
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
                self.layer.borderColor = UIColor.label.cgColor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 개발 문서상으로는 iOS 17.0 부터 Deprecated 되었음.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.layer.borderColor = UIColor.label.cgColor
    }
    
}
