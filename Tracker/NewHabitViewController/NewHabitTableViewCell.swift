//
//  NewHabitTableViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 13.07.2024.
//

import Foundation
import UIKit

final class NewHabitTableViewCell: UITableViewCell {
    private let stackView = UIStackView()
    private let label = UILabel()
    private let daysLabel = UILabel()
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    static let reuseIdentifier = "NewHabitTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = Colors.textFieldBackground
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(daysLabel)
        
        daysLabel.textColor = .gray
        chevronImageView.tintColor = .gray
        
        contentView.addSubview(stackView)
        contentView.addSubview(chevronImageView)
        
        [stackView, daysLabel, label, chevronImageView].forEach {
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
    
    func setSelectedDays(_ selectedDays: String) {
        daysLabel.text = selectedDays
        daysLabel.isHidden = selectedDays.isEmpty
    }
}
