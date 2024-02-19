//
//  ContentView.swift
//  CookTimer
//
//  Created by 武林慎太郎 on 2024/02/15.
//

import SwiftUI
import Combine
import Foundation

struct ContentView: View {
    @StateObject var vm = viewModel()
    
        var body: some View {
            NavigationStack {
                List {
                    ForEach(vm.timers) {
                        timer in
                        TimerView(timerId: timer.id, vm: vm)
                    }
                }
                .navigationTitle("CookTimer")
                .toolbar {
                    Button("add Timer") {
                        let newTimer = TimerModel(endDate: nil, lefting: "0:00", isActive: false, minutes:0.0 ,savedTimeRemaining: 0)
                        vm.timers.append(newTimer)
                    }
                }
            }
        }
}

#Preview {
    ContentView()
}
