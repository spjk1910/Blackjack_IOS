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

// Observable object to manage selection state
class SelectedObject: ObservableObject {
    @Published var isShowing = false
    @Published var name = ""
}

struct GuideView: View {
    // Environment objects for localization, theme management, and music control
    @EnvironmentObject var readJson: ConvertJson
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var musicManager: BackgroundMusicManager
    
    // Namespace for animations
    @Namespace var animation
    
    // App storage to keep track of the selected language
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    // State object to manage selected object state
    @StateObject var selectedObject = SelectedObject()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color based on the current theme
                Color(themeManager.colorScheme == .dark ? Color("Dark") : Color("Light"))
                    .ignoresSafeArea()
                
                // Main content stack
                ZStack {
                    HowToPlayView(animation: animation)
                        .environmentObject(selectedObject) // Provide SelectedObject as environment object
                        .zIndex(1.0)
                    
                    // Detail view, conditionally displayed based on isShowing
                    if selectedObject.isShowing {
                        HowToPlayDetailView(animation: animation) // Use the environment object
                            .environmentObject(selectedObject) // Pass the existing instance
                            .zIndex(2.0)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {SoundManager.shared.playSound(named: "MouseClick")})
                
                // Conditionally render < Back button
                if !selectedObject.isShowing {
                    HStack {
                        NavigationLink(destination: WelcomeScreen()) {
                            HStack {
                                // Chevron icon
                                Image(systemName: "chevron.left")
                                    .font(.system(size: isPhone() ? 20 : 40, weight: .bold))
                                    .foregroundColor(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                
                                Text(readJson.localizedString(forKey: "back"))
                                    .font(.custom("MTD-Afecta", size: isPhone() ? 30 : 50))
                                    .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                    .padding(.top, isPhone() ? 4 : 6)
                            }
                        }
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                SoundManager.shared.playSound(named: "MouseClick")
                            }
                        )
                        .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.bottom, isPhone() ? 300 : 750)
                    .zIndex(3.0) // Ensure the < Back button is on top of all other views
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // Set the language based on the stored value
                readJson.selectedLanguage = selectedLanguage == "English" ? "en" : "vi"
                
                // Manage background music based on user preference
                if musicManager.isMusicOn {
                    musicManager.setMusicState(isOn: true)
                }
            }
        }
    }
}

struct GuideView_Preview: PreviewProvider {
    static var previews: some View {
        let convertJson = ConvertJson()
        let themeManager = ThemeManager()
        let musicManager = BackgroundMusicManager()
        
        convertJson.selectedLanguage = "en"
        
        return Group {
            GuideView()
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone")
            
            GuideView()
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro 11-inch (M4)"))
                .previewDisplayName("iPad")
        }
    }
}
