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

// A view for creating a new player by entering their name.
struct PlayerCreationView: View {
    @Binding var playerName: String // Binding for the player's name input
    @EnvironmentObject var readJson: ConvertJson // Environment object for JSON conversion (if needed)
    @Environment(\.presentationMode) var presentationMode // Environment value for controlling view presentation
    @EnvironmentObject var themeManager: ThemeManager // Environment object for managing app theme
    @EnvironmentObject var musicManager: BackgroundMusicManager // Environment object for managing background music
    
    var body: some View {
        ZStack {
            // Background color based on the current theme
            Color(themeManager.colorScheme == .dark ? Color("Dark") : Color("Light"))
                .ignoresSafeArea(.all)
            
            VStack {
                // Title Text
                Text("Enter Your Name")
                    .font(.custom("MTD-Afecta", size: isPhone() ? 40 : 80))
                    .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                
                // TextField for entering the player's name
                TextField("Player Name ...", text: $playerName)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(themeManager.colorScheme == .dark ? .white : .black, lineWidth: 4)
                    )
                    .font(.custom("iCiel Altus", size: isPhone() ? 20 : 40))
                    .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                    .padding()
                    .autocapitalization(.none)
                
                // Button to start the game
                Button("Start Game") {
                    if !playerName.isEmpty {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view if player name is provided
                    }
                }
                .font(.custom("iCiel Altus", size: isPhone() ? 25 : 40))
                .disabled(playerName.isEmpty) // Disable button if player name is empty
                .padding()
                .background(Color("Button"))
                .foregroundColor(Color("Light"))
                .cornerRadius(10)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct PlayerCreationView_Preview: PreviewProvider {
    static var previews: some View {
        let convertJson = ConvertJson()
        let themeManager = ThemeManager()
        let musicManager = BackgroundMusicManager()
        
        convertJson.selectedLanguage = "en" // Set a default language
        
        return Group {
            // Preview for iPhone
            PlayerCreationView(playerName: .constant(""))
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone")
                
            // Preview for iPad
            PlayerCreationView(playerName: .constant(""))
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro 11-inch (M4)"))
                .previewDisplayName("iPad")
        }
        .navigationBarHidden(true) // Hide navigation bar in previews
    }
}
