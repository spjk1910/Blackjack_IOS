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

// Enum to represent different tabs
enum TabItem {
    case standard
    case timer
}

struct LeaderboardTabView: View {
    
    @Binding var selectedTab: TabItem
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color("Arrow")
                .opacity(0.4)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack(spacing: 0) {
                Spacer()
                
                // Standard tab button
                Button(action: {
                    selectedTab = .standard
                }) {
                    VStack {
                        Text("Standard")
                            .font(.custom("iCiel Altus", size: isPhone() ? 24 : 48))
                            .foregroundStyle(Color("Light"))
                    }
                    .padding()
                    .frame(width: isPhone() ? 150 : 200, height: isPhone() ? 50 : 80)
                    .background(selectedTab == .standard ? Color("Arrow") : Color.clear)
                    .cornerRadius(10)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    SoundManager.shared.playSound(named: "MouseClick")
                })
                
                Spacer()
                
                // Divider
                Rectangle()
                    .fill(Color("Arrow"))
                    .frame(width: 4)
                    .padding(.vertical, 10)
                
                Spacer()
                
                // Timer tab button
                Button(action: {
                    selectedTab = .timer
                }) {
                    VStack {
                        Text("Timer")
                            .font(.custom("iCiel Altus", size: isPhone() ? 24 : 48))
                            .foregroundStyle(Color("Light"))
                    }
                    .padding()
                    .frame(width: isPhone() ? 150 : 200, height: isPhone() ? 50 : 80)
                    .background(selectedTab == .timer ? Color("Arrow") : Color.clear)
                    .cornerRadius(10)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    SoundManager.shared.playSound(named: "MouseClick")
                })
                
                Spacer()
            }
        }
        .frame(width: isPhone() ? 450 : 600, height: isPhone() ? 50 : 80)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
    }
}

struct LeaderboardTabView_Preview: PreviewProvider {
    static var previews: some View {
        let convertJson = ConvertJson()
        @State var selectedTab: TabItem = .timer
        
        convertJson.selectedLanguage = "en"
        
        return Group {
            LeaderboardTabView(selectedTab: $selectedTab)
                .environmentObject(convertJson)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone")
                
            LeaderboardTabView(selectedTab: $selectedTab)
                .environmentObject(convertJson)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro 11-inch (M4)"))
                .previewDisplayName("iPad")
        }
    }
}
