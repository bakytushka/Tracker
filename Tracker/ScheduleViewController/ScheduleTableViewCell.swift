//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 14.07.2024.
//

import Foundation
import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let switchView = UISwitch()
    
    static let reuseIdentifier = "ScheduleTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        switchView.onTintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1.0)
        switchView.setOn(false, animated: true)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switchView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            switchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchView.widthAnchor.constraint(equalToConstant: 51),
            switchView.heightAnchor.constraint(equalToConstant: 31),
            switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func configureCell(title: String, isSwitchOn: Bool) {
        titleLabel.text = title
        switchView.isOn = isSwitchOn
    }
}
