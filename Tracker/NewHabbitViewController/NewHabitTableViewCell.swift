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
   //     stackView.axis = .horizontal
  //      stackView.alignment = .center
   //     stackView.distribution = .equalSpacing
   //     stackView.spacing = 8
        
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        
  //      stackView.alignment = .center  // Изменено на .center для центрирования лейблов по вертикали
   //         stackView.distribution = .equalCentering  // Изменено на .equalCentering для равного распределения элементов
        
        
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        
        dayslabel.textColor = .gray
        
        dayslabel.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.tintColor = .gray
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(dayslabel)
   //     stackView.addArrangedSubview(chevronImageView)
        
  //      contentView.layer.cornerRadius = 16
  //      contentView.layer.masksToBounds = true
        
        contentView.addSubview(stackView)
        contentView.addSubview(chevronImageView) // Добавлено

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            
/*                     stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.heightAnchor.constraint(equalToConstant: 46), */
            
   //         chevronImageView.heightAnchor.constraint(equalToConstant: 12),
     //       chevronImageView.widthAnchor.constraint(equalToConstant: 7),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setTitle(_ model: String) {
        label.text = model
    }
    
    func setDescription(_ model: String) {
        dayslabel.text = model
        if dayslabel.text != "" {
            dayslabel.isHidden = false
        } else {
            dayslabel.isHidden = true
        }
    }
}
