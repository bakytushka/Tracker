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
    let schedule: Schedule
}

enum Schedule {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    case none
}
