//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 14.07.2024.
//

import Foundation
import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    //   let stackView = UIStackView()
    let label = UILabel()
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
        
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        switchView.onTintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1.0)
        
        switchView.setOn(false, animated: true)
        switchView.addTarget(
            self,
            action: #selector(switchViewChanged),
            for: .valueChanged
        )
        
        switchView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switchView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 22),
            
            switchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchView.widthAnchor.constraint(equalToConstant: 51),
            switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ])
    }
    
    func configure(title: String, isSwitchOn: Bool) {
        label.text = title
        switchView.isOn = isSwitchOn
    }
    
    @objc private func switchViewChanged() {
        
    }
}
