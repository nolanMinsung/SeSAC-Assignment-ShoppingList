//
//  ShoppingListFilteringButton.swift
//  Assignment-ShoppingList
//
//  Created by 김민성 on 7/27/25.
//

import UIKit


final class ShoppingListFilteringButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .label : .clear
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
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
