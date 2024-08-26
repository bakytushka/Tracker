//
//  FilterTableViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 26.08.2024.
//

import Foundation
import UIKit

final class FilterTableViewCell: UITableViewCell {
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.separator
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                view.heightAnchor.constraint(equalToConstant: 0.5),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            return view
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
        
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        selectionStyle = .none
    }
    
    func configureSeparator(isLastCell: Bool) {
            separatorView.isHidden = isLastCell
        }
}
