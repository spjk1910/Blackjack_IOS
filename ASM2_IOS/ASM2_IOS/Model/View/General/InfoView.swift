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

// A view that displays information about the app, including author and program details.
struct InfoView: View {
    @Binding var showingInfo: Bool // Controls the visibility of the info view
    @EnvironmentObject var readJson: ConvertJson // Provides localized strings
    @AppStorage("selectedLanguage") private var selectedLanguage = "English" // Stores the selected language
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                Button(action: {
                    SoundManager.shared.playSound(named: "MouseClick") // Play sound on button click
                    withAnimation { showingInfo.toggle() } // Toggle visibility with animation
                }) {
                    Text("X")
                        .foregroundColor(Color("Dark"))
                }
            }
            
            HStack {
                Spacer()
                Text(readJson.localizedString(forKey: "appAuthor"))
                    .font(.custom("MTD-Afecta", size: isPhone() ? 40 : 50))
                    .foregroundStyle(Color("Dark"))
                Spacer()
            }
            
            Text(" \(readJson.localizedString(forKey: "name")): \(selectedLanguage == "English" ? "Doan Phan Thuy Trang" : "Đoàn Phan Thùy Trang")")
                .font(.custom("iCiel Altus", size: isPhone() ? 24 : 30))
                .foregroundStyle(Color("Dark"))
            
            Text(" \(readJson.localizedString(forKey: "sID")): s4027648")
                .font(.custom("iCiel Altus", size: isPhone() ? 24 : 30))
                .foregroundStyle(Color("Dark"))
            
            Text(" \(readJson.localizedString(forKey: "program")): \(selectedLanguage == "English" ? "Software Engineering" : "Kỹ Sư Phần Mềm")")
                .font(.custom("iCiel Altus", size: isPhone() ? 24 : 30))
                .foregroundStyle(Color("Dark"))
        }
        .onAppear {
            readJson.selectedLanguage = selectedLanguage == "English" ? "en" : "vi" // Set the language for localization
        }
    }
}

// A view modifier that adds an info overlay to a view.
struct InfoOverlay: ViewModifier {
    @Binding var showingInfo: Bool // Controls the visibility of the overlay
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if showingInfo {
                        InfoView(showingInfo: $showingInfo) // Display the info view when showingInfo is true
                            .padding(30)
                            .background(.white.opacity(0.9)) // Background with slight opacity
                            .cornerRadius(10)
                            .shadow(radius: 20) // Shadow for a lifted effect
                            .frame(width: isPhone() ? 500 : 600, height: isPhone() ? 500 : 600) // Set frame size based on device
                            .padding()
                    }
                }
            )
    }
}

extension View {
    // Adds an info overlay to the view.
    func infoView(showingInfo: Binding<Bool>) -> some View {
        self.modifier(InfoOverlay(showingInfo: showingInfo))
    }
}

// Helper function to determine if the device is an iPhone.
func isPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}
