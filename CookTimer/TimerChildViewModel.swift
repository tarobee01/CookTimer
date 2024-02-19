//
//  TimerChildViewModel.swift
//  CookTimer
//
//  Created by 武林慎太郎 on 2024/02/19.
//

import Foundation

class TimerChildViewModel: ObservableObject, Identifiable {
    @Published var timer: TimerModel
    var id = UUID()
    //終わりの時刻を設定し、タイマーをアクティブにする
    func start() {
        let now = Date()
        let calendar = Calendar.current
        
        //中断していた場合
        if timer.savedTimeRemaining > 0 {
            timer.endDate = now.addingTimeInterval(timer.savedTimeRemaining)
        } else {
        //新しくスタートする場合
            timer.endDate = calendar.date(byAdding: .second, value: Int(timer.minutes), to: now)
        }
        timer.isActive = true
    }
    
    //一秒ごとに実行される関数。現在の時刻とendDateの距離を計算する。つまり、残り時間を計算している。
    func upDate() {
        if timer.isActive == false {
            return
        }
        
        let now = Date()
        guard let checkedEndDate = timer.endDate else {
            print("not have endDate")
            return
        }
        
        let diff = checkedEndDate.timeIntervalSince1970 - now.timeIntervalSince1970
        let diffDate = Date(timeIntervalSince1970: diff)
        let calendar = Calendar.current
        
        let minutes = calendar.component(.minute, from: diffDate)
        let secondes = calendar.component(.second, from: diffDate)
            timer.lefting = String(format: "%d: %02d", minutes, secondes)
    }
    
    //タイマーの残りの時間を保存して、非アクティブにする
    func stop() {
        let now = Date()
        timer.savedTimeRemaining = timer.endDate?.timeIntervalSince(now) ?? 0
        timer.isActive = false
    }
    
    func setTimer(newValue: TimeInterval) {
        let calendar = Calendar.current
        let datedNewValue = Date(timeIntervalSince1970: newValue)
        let minutes = calendar.component(.minute, from: datedNewValue)
        let secondes = calendar.component(.second, from: datedNewValue)
        timer.lefting = String(format: "%d: %02d", minutes, secondes)
        timer.savedTimeRemaining = 0
    }
    
    init(timer: TimerModel) {
        self.timer = timer
    }
}
