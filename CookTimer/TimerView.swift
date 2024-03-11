import SwiftUI

struct TimerView: View {
    @ObservedObject var timerChildVm: TimerChildViewModel
    @ObservedObject var timerVm: viewModel
    @State var selectedColorScheme: ColorScheme
    private let eventTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private static let colorSchemes: [ColorScheme] = [
            ColorScheme(name: "Yellow", backgroundColor: Color.yellow.opacity(0.2)),
            ColorScheme(name: "White", backgroundColor: Color.white),
            ColorScheme(name: "Blue", backgroundColor: Color.blue.opacity(0.2))
        ]
    
    init(timerChildVm: TimerChildViewModel, timerVm: viewModel) {
        self.timerChildVm = timerChildVm
        self.timerVm = timerVm
        self._selectedColorScheme = State(initialValue: TimerView.colorSchemes[1])
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("timerName", text: $timerChildVm.timer.timerName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Picker("", selection: $selectedColorScheme) {
                    ForEach(TimerView.colorSchemes) { colorScheme in
                        Text(colorScheme.name).tag(colorScheme)
                    }
                }
                .pickerStyle(.menu)
            }
            HStack {
                Button(action: {
                    timerChildVm.timer.minutes += 10
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 25))
                        .opacity(0.8)
                }
                .buttonStyle(.plain)
                .disabled(timerChildVm.timer.isActive == true)
                Text("\(timerChildVm.timer.lefting)")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .foregroundColor(.black)
                Button(action: {
                    if timerChildVm.timer.minutes >= 10 {
                        timerChildVm.timer.minutes -= 10
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 25))
                        .opacity(0.8)
                }
                .buttonStyle(.plain)
                .disabled(timerChildVm.timer.isActive == true)
            }
            Slider(value: $timerChildVm.timer.minutes, in: 0...2000, step: 15)
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
                        .background(timerChildVm.timer.isActive ? Color.gray : Color.green.opacity(0.8))  // アクティブ状態によって背景色を変更
                        .foregroundColor(.white)
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
                        .background(timerChildVm.timer.isActive ? Color.red.opacity(0.8) : Color.gray)  // アクティブ状態によって背景色を変更
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!timerChildVm.timer.isActive)
                .buttonStyle(.plain)
                
            }
            .padding()
            HStack {
                Spacer()
                Button(action: {
                    timerVm.deleteTimerbyButton(id: timerChildVm.id)
                }, label: {
                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                        .opacity(0.8)
                })
                .buttonStyle(.plain)
            }
            
        }
        .padding()
        .background(selectedColorScheme.backgroundColor)
        .cornerRadius(20)
        .shadow(radius: 5)
        .onReceive(eventTimer, perform: { _ in
            timerChildVm.upDate()
        })
    }
}

#Preview {
    TimerView(timerChildVm: TimerChildViewModel(timer: TimerModel(timerName: "", lefting: "0:00", isActive: false, minutes: 0, savedTimeRemaining: 0)), timerVm: viewModel())
}
