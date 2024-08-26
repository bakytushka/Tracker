//
//  Constants.swift
//  Tracker
//
//  Created by Bakyt Temishov on 15.07.2024.
//

import Foundation
import UIKit

enum Constant {
    static let emojies: [String] = [
    "🙂", "😻", "🌺", "🐶", "❤️", "😱",
    "😇", "😡", "🥶", "🤔", "🙌", "🍔",
    "🥦", "🏓", "🥇", "🎸", "🌴", "😪",
    ]
    
    static let daysOfWeekTitles = [
        "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"
    ]
    static let filterTitles = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    static let colorSelection = (1...18).map({ UIColor(named: String($0)) })
    static let collectionViewTitles = ["Emoji", "Цвет"]
}

enum Colors {
    static let buttonActive = UIColor.black
    static let buttonInactive = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
    static let cancelButtonColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1.0)
    static let textFieldBackground = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
    static let switchViewColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1.0)
}

enum TrackerFilter {
    case all
    case today
    case completed
    case uncompleted
}

extension Constant {
    static func randomEmoji() -> String {
        return emojies.randomElement() ?? "🤪"
    }
}

extension UIView {
    func addGradientBorder(colors: [UIColor], width: CGFloat = 2, cornerRadius: CGFloat = 16) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
    }
}
