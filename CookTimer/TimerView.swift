//
//  TimerView.swift
//  CookTimer
//
//  Created by 武林慎太郎 on 2024/02/15.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timerChildVm: TimerChildViewModel
    @ObservedObject var timerVm: viewModel
    
    private let eventTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("\(timerChildVm.timer.lefting)")
                .font(.largeTitle)
                .fontWeight(.light)
            Slider(value: $timerChildVm.timer.minutes, in: 0...1000, step: 15)
                .onChange(of: timerChildVm.timer.minutes) { newValue in
                    timerChildVm.setTimer(newValue: newValue)
                }
                .disabled(timerChildVm.timer.isActive == true)
            HStack(spacing: 20) {  // ボタン間のスペースを設定
                // Start ボタン
                Button(action: {
                    timerChildVm.start()
                }) {
                    Text("Start")
                        .fontWeight(.medium)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(timerChildVm.timer.isActive ? Color.gray : Color.green)  // アクティブ状態によって背景色を変更
                        .cornerRadius(10)
                }
                .disabled(timerChildVm.timer.isActive)
                .buttonStyle(.plain)
                
                // Stop ボタン
                Button(action: {
                    timerChildVm.stop()
                }) {
                    Text("Stop")
                        .fontWeight(.medium)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(timerChildVm.timer.isActive ? Color.red : Color.gray)  // アクティブ状態によって背景色を変更
                        .cornerRadius(10)
                }
                .disabled(!timerChildVm.timer.isActive)
                .buttonStyle(.plain)
            }
            .padding()
        }
        .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
        .onReceive(eventTimer, perform: { _ in
            timerChildVm.upDate()
        })
    }
}

#Preview {
    TimerView(timerChildVm: TimerChildViewModel(timer: TimerModel(lefting: "0:00", isActive: false, minutes: 0, savedTimeRemaining: 0)), timerVm: viewModel())
}
