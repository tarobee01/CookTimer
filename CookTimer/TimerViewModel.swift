//
//  TimerViewModel.swift
//  CookTimer
//
//  Created by 武林慎太郎 on 2024/02/15.
//
import Foundation
import Combine
import SwiftUI

@MainActor
class viewModel: ObservableObject {
    @Published var timers: [TimerChildViewModel] = []
    
    func addTimer() {
        let newTimer = TimerChildViewModel(timer: TimerModel(timerName: "", lefting: "0:00", isActive: false, minutes: 0, savedTimeRemaining: 0))
        timers.append(newTimer)
    }
    
    func deleteTimers(at offsets: IndexSet) {
          timers.remove(atOffsets: offsets)
      }
    
    func deleteTimerbyButton(id: UUID) {
        withAnimation {
            timers.removeAll{$0.id == id}
        }
    }
}
