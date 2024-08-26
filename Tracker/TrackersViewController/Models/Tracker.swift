//
//  Tracker.swift
//  Tracker
//
//  Created by Bakyt Temishov on 02.07.2024.
//

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [String]
    
    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: [String]) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}

enum WeekDay: Int, CaseIterable {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 0
    
    var stringValue: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}

enum TrackerType {
    case habit
    case event
}

extension WeekDay {
    static func from(string: String) -> WeekDay? {
        switch string {
        case "Пн": return .monday
        case "Вт": return .tuesday
        case "Ср": return .wednesday
        case "Чт": return .thursday
        case "Пт": return .friday
        case "Сб": return .saturday
        case "Вс": return .sunday
        default: return nil
        }
    }
}
