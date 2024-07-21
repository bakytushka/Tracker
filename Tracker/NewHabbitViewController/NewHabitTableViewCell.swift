//
//  NewHabitTableViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 13.07.2024.
//

import Foundation
import UIKit

final class NewHabitTableViewCell: UITableViewCell {
    let stackView = UIStackView()
    let label = UILabel()
    let dayslabel = UILabel()
    let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    static let reuseIdentifier = "NewHabitTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(dayslabel)
        
        dayslabel.textColor = .gray
        chevronImageView.tintColor = .gray
        
        contentView.addSubview(stackView)
        contentView.addSubview(chevronImageView)
        
        [stackView, dayslabel, label, chevronImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }

    func setDescription(_ description: String) {
        dayslabel.text = description
        dayslabel.isHidden = description.isEmpty
    }
}
