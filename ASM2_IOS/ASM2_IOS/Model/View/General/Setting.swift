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
import AVFoundation

struct Setting: View {
    let title: String
    let option: [String]
    let value: (String) -> String
    let description: String
    @Binding var selectedOption: String
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack(alignment: .leading) {
            // Background Color
            themeManager.colorScheme == .dark ? Color("Dark") : Color("Light")
            
            // Title
            Text(title)
                .font(.custom("MTD-Afecta", size: isPhone() ? 30 : 60))
                .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                .padding(.leading, isPhone() ? 100 : 100)
            
            // Display the selected option and its description
            VStack {
                Text(value(selectedOption))
                    .font(.custom("iCiel Altus", size: isPhone() ? 20 : 40))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                
                Text(description)
                    .font(.custom("iCiel Altus", size: isPhone() ? 15 : 24))
                    .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                    .multilineTextAlignment(.center)
            }
            .padding(.leading, isPhone() ? 350 : 350)
            
            // Chevron buttons
            HStack {
                // Left arrow button
                Button(action: {
                    SoundManager.shared.playSound(named: "MouseClick")
                    
                    if let currentIndex = option.firstIndex(of: selectedOption), currentIndex > 0 {
                        selectedOption = option[currentIndex - 1]
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .foregroundStyle(Color("Arrow"))
                        .opacity(selectedOption == option.first ? 0.5 : 1)
                }
                .disabled(selectedOption == option.first)
                
                Spacer()
                    .frame(width: isPhone() ? 185 : 185)
                
                // Right arrow button
                Button(action: {
                    SoundManager.shared.playSound(named: "MouseClick")
                    
                    if let currentIndex = option.firstIndex(of: selectedOption), currentIndex < option.count - 1 {
                        selectedOption = option[currentIndex + 1]
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color("Arrow"))
                        .opacity(selectedOption == option.last ? 0.5 : 1)
                }
                .disabled(selectedOption == option.last)
            }
            .padding(.leading, isPhone() ? 300 : 300)
        }
    }
}

struct Setting_Previews: PreviewProvider {
    @State static var selectedOption = "English"
    static let themeManager = ThemeManager()
    
    static var previews: some View {
        // Preview for iPhone devices
        Setting(
            title: "Language",
            option: ["English", "Tiếng Việt"],
            value: { $0 },
            description: "Tiến trình trò chơi sẽ không save!",
            selectedOption: $selectedOption
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
        .previewDisplayName("IPhone")
        .environmentObject(themeManager)
        
        // Preview for iPad devices
        Setting(
            title: "Language",
            option: ["English", "Tiếng Việt"],
            value: { $0 },
            description: "Choose your preferred language",
            selectedOption: $selectedOption
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .previewDevice(PreviewDevice(rawValue: "iPad Pro 11-inch (M4)"))
        .previewDisplayName("IPad")
        .environmentObject(themeManager)
    }
}
