//
//  TrackersViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 08.07.2024.
//

import Foundation
import UIKit

final class TrackersViewCell: UICollectionViewCell {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
           
           NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
