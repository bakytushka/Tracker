//
//  CategoryViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 14.08.2024.
//

import Foundation
import UIKit

final class CategoryViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    static let reuseIdentifier = "CategoryViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func setupViews(){
        backgroundColor = Colors.textFieldBackground
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
