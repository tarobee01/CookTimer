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
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject private var orientationObserver = OrientationObserver()
    
    var body: some View {
        NavigationStack {
            if orientationObserver.orientation.isPortrait {
                List {
                    ForEach(vm.timers) { timer in
                        TimerView(timerChildVm: timer, timerVm: vm)
                    }
                    .onDelete { indexSet in
                        vm.deleteTimers(at: indexSet)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("CookTimer")
                .toolbar {
                    Button(action: {
                        vm.addTimer()
                    }) {
                        Image(systemName: "timer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding()
                    }
                }
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(vm.timers) { timer in
                            TimerView(timerChildVm: timer, timerVm: vm)
                                .frame(width: 250, height: 250)
                        }
                    }
                }
                .navigationTitle("CookTimer")
                .toolbar {
                    Button(action: {
                        vm.addTimer()
                    }) {
                        Image(systemName: "timer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding()
                    }
                }
            }
        }
    }
}

class OrientationObserver: ObservableObject {
    @Published var orientation: UIDeviceOrientation = .portrait

    init() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc private func didChangeOrientation() {
        orientation = UIDevice.current.orientation
    }
}

#Preview {
    ContentView()
}
