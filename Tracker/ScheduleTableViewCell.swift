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
    let swithView = UISwitch()
    
    static let reuseIdentifier = "ScheduleTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*    private func setupViews() {
     stackView.axis = .horizontal
     stackView.alignment = .center
     stackView.distribution = .equalSpacing
     stackView.spacing = 8
     backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
     
     label.translatesAutoresizingMaskIntoConstraints = false
     swithView.translatesAutoresizingMaskIntoConstraints = false
     swithView.tintColor = .gray
     
     stackView.addArrangedSubview(label)
     stackView.addArrangedSubview(swithView)
     
     //      contentView.layer.cornerRadius = 16
     //      contentView.layer.masksToBounds = true
     
     contentView.addSubview(stackView)
     stackView.translatesAutoresizingMaskIntoConstraints = false
     
     NSLayoutConstraint.activate([
     stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
     stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
     stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
     stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
     ])
     }
     } */
    
    private func setupViews(){
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
//        swithView.onTintColor = .blue
      //  let switchView = UISwitch(frame: CGRect(x: 100, y: 100, width: 0, height: 0))
        swithView.onTintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1.0)
        
        swithView.setOn(false, animated: true)
        swithView.addTarget(
            self,
            action: #selector(switchViewChanged),
            for: .valueChanged
        )
        
        swithView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(swithView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 22),
            
            swithView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            swithView.widthAnchor.constraint(equalToConstant: 51),
            swithView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ])
    }
    @objc private func switchViewChanged() {
        
    }
}
