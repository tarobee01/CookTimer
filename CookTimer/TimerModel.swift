//
//  TimerModel.swift
//  CookTimer
//
//  Created by 武林慎太郎 on 2024/02/15.
//

import Foundation

struct TimerModel: Identifiable {
    var id = UUID()
    var endDate: Date?
    var lefting: String
    var isActive: Bool
    var minutes: Double
    var savedTimeRemaining: TimeInterval
    
    init(id: UUID = UUID(), endDate: Date? = nil, lefting: String, isActive: Bool, minutes: Double, savedTimeRemaining: TimeInterval) {
        self.id = id
        self.endDate = endDate
        self.lefting = lefting
        self.isActive = isActive
        self.minutes = minutes
        self.savedTimeRemaining = savedTimeRemaining
    }
}
