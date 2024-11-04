/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Doan Phan Thuy Trang
  ID: s4027648
  Created date: 16/08/2024
  Last modified: 31/08/2024
  Acknowledgement:
        - Youtube
        - Freepik
        - Pinterest
        - Stackoverflow
        - https://opengameart.org/content/playing-cards-vector-png (Card Asset)
*/

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var timeManager: TimeManager
    @State private var timeRemaining: TimeInterval = 10
    @State private var timer: Timer?
    @State private var isRunning: Bool = false
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(lineWidth: isPhone() ? 5 : 10)
                .opacity(0.3)
                .foregroundStyle(Color("Button"))
            
            // Progress circle showing remaining time
            Circle()
                .trim(from: 0, to: CGFloat(1 - (timeManager.timeRemaining / 10)))
                .stroke(style: StrokeStyle(
                    lineWidth: isPhone() ? 5 : 10,
                    lineCap: .round,
                    lineJoin: .round
                ))
                .foregroundStyle(Color("Button"))
                .rotationEffect(.degrees(-90))
            
            // Display formatted time
            Text(formattedTime())
                .font(.custom("iCiel Altus", size: isPhone() ? 20 : 30))
                .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
        }
        .frame(maxWidth: 100)
    }
    
    // Helper function to format the remaining time
    private func formattedTime() -> String {
        let minutes = Int(timeManager.timeRemaining) / 60
        let seconds = Int(timeManager.timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerView_Preview: PreviewProvider {
    static var previews: some View {
        let timeManager = TimeManager()
        let themeManager = ThemeManager()
        
        return Group {
            TimerView()
                .environmentObject(timeManager)
                .environmentObject(themeManager)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone")
                
            TimerView()
                .environmentObject(timeManager)
                .environmentObject(themeManager)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro 11-inch (M4)"))
                .previewDisplayName("iPad")
        }
    }
}
