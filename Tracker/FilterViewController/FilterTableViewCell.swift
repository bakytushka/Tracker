//
//  FilterTableViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 26.08.2024.
//

import Foundation
import UIKit

class FilterTableViewCell: UITableViewCell {
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(checkmarkImageView)
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.7),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        checkmarkImageView.isHidden = true
    }
    
    func configure(with title: String, isSelected: Bool) {
        textLabel?.text = title
        checkmarkImageView.isHidden = !isSelected
    }
}
