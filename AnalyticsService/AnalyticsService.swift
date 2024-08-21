//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Bakyt Temishov on 21.08.2024.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    func logEvent(_ event: String, screen: String = "Main", item: String? = nil) {
        var parameters: [String: Any] = [
            "event": event,
            "screen": screen
        ]
        if let item = item {
            parameters["item"] = item
        }
        YMMYandexMetrica.reportEvent("ui_event", parameters: parameters, onFailure: { error in
            print("Failed to report event: \(error.localizedDescription)")
        })
        
        print("Event reported: \(parameters)")
    }
}
