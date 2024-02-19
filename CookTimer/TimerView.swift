//
//  TimerView.swift
//  CookTimer
//
//  Created by 武林慎太郎 on 2024/02/15.
//

import SwiftUI

struct TimerView: View {
    let timerId: UUID
    @ObservedObject var vm: viewModel
    private let eventTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        if let timerIndex = vm.timers.firstIndex(where: { $0.id == timerId }) {
            VStack {
                Text("\(vm.timers[timerIndex].lefting)")
                    .font(.largeTitle)
                    .fontWeight(.light)
                Slider(value: $vm.timers[timerIndex].minutes, in: 0...1000, step: 15)
                    .onChange(of: vm.timers[timerIndex].minutes) { newValue in
                        vm.setTimer(newValue: newValue, id: timerId)
                    }
                    .disabled(vm.timers[timerIndex].isActive == true)
                HStack(spacing: 20) {  // ボタン間のスペースを設定
                    // Start ボタン
                    Button(action: {
                        vm.start(id: timerId)
                    }) {
                        Text("Start")
                            .fontWeight(.medium)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(vm.timers[timerIndex].isActive ? Color.gray : Color.green)  // アクティブ状態によって背景色を変更
                            .cornerRadius(10)
                    }
                    .disabled(vm.timers[timerIndex].isActive)
                    .buttonStyle(.plain)
                    
                    // Stop ボタン
                    Button(action: {
                        vm.stop(id: timerId)
                    }) {
                        Text("Stop")
                            .fontWeight(.medium)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(vm.timers[timerIndex].isActive ? Color.red : Color.gray)  // アクティブ状態によって背景色を変更
                            .cornerRadius(10)
                    }
                    .disabled(!vm.timers[timerIndex].isActive)
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .onReceive(eventTimer, perform: { _ in
                vm.upDate(id: timerId)
            })
        } else {
            VStack {
                Text("timer not found")
            }
        }
        
    }
}

#Preview {
    TimerView(timerId: UUID(), vm: viewModel())
}
