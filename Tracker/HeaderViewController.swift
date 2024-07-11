//
//  HeaderViewController.swift
//  Tracker
//
//  Created by Bakyt Temishov on 09.07.2024.
//

import Foundation
import UIKit

final class HeaderViewController: UICollectionReusableView {
    static let reuseIdentifier = "Header"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTitleLabel() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.tintColor = .black
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
    }
}
