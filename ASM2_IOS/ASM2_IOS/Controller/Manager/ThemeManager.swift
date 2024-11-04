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

// Manages the application's theme settings
class ThemeManager: ObservableObject {
    // Published property to track the color scheme (light or dark)
    @Published var colorScheme: ColorScheme = .light
    
    // AppStorage property to persist the selected theme across app launches
    @AppStorage("selectedTheme") private var selectedTheme: String = "Light"
    
    // Initializer to set the theme based on the stored selected theme
    init() {
        setTheme(selectedTheme)
    }
    
    // Function to set the color scheme based on the provided theme string
    func setTheme(_ theme: String) {
        switch theme {
            case "Dark", "Tối":
                colorScheme = .dark
            default:
                colorScheme = .light
        }
    }
}
