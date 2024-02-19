//
//  TimerViewModel.swift
//  CookTimer
//
//  Created by 武林慎太郎 on 2024/02/15.
//
import Foundation
import Combine

@MainActor
class viewModel: ObservableObject {
    @Published var timers: [TimerModel] = []

    
    //終わりの時刻を設定し、タイマーをアクティブにする
    func start(id: UUID) {
        guard let index = timers.firstIndex(where: { $0.id == id }) else { return }
        let now = Date()
        let calendar = Calendar.current
        
        //中断していた場合
        if timers[index].savedTimeRemaining > 0 {
            timers[index].endDate = now.addingTimeInterval(timers[index].savedTimeRemaining)
        } else {
        //新しくスタートする場合
            timers[index].endDate = calendar.date(byAdding: .second, value: Int(timers[index].minutes), to: now)
        }
        timers[index].isActive = true
    }
    
    //一秒ごとに実行される関数。現在の時刻とendDateの距離を計算する。つまり、残り時間を計算している。
    func upDate(id: UUID) {
        guard let index = timers.firstIndex(where: { $0.id == id }) else { return }
        if timers[index].isActive == false {
            return
        }
        
        let now = Date()
        guard let checkedEndDate = timers[index].endDate else {
            print("not have endDate")
            return
        }
        
        let diff = checkedEndDate.timeIntervalSince1970 - now.timeIntervalSince1970
        let diffDate = Date(timeIntervalSince1970: diff)
        let calendar = Calendar.current
        
        let minutes = calendar.component(.minute, from: diffDate)
        let secondes = calendar.component(.second, from: diffDate)
            timers[index].lefting = String(format: "%d: %02d", minutes, secondes)
    }
    
    //タイマーの残りの時間を保存して、非アクティブにする
    func stop(id: UUID) {
        guard let index = timers.firstIndex(where: { $0.id == id }) else { return }
        let now = Date()
        timers[index].savedTimeRemaining = timers[index].endDate?.timeIntervalSince(now) ?? 0
        timers[index].isActive = false
    }
    
    func setTimer(newValue: TimeInterval, id: UUID) {
        guard let index = timers.firstIndex(where: { $0.id == id }) else { return }
        let calendar = Calendar.current
        let datedNewValue = Date(timeIntervalSince1970: newValue)
        let minutes = calendar.component(.minute, from: datedNewValue)
        let secondes = calendar.component(.second, from: datedNewValue)
        timers[index].lefting = String(format: "%d: %02d", minutes, secondes)
        timers[index].savedTimeRemaining = 0
    }
}
