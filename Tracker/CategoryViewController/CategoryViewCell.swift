//
//  CategoryViewCell.swift
//  Tracker
//
//  Created by Bakyt Temishov on 14.08.2024.
//

import Foundation
import UIKit

final class CategoryViewCell: UITableViewCell {
    static let reuseIdentifier = "CategoryViewCell"

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            // Дополнительная настройка ячейки
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
}
