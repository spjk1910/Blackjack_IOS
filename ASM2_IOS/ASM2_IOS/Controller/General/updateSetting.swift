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

import Foundation

// Function to update user settings based on the selected options
func updateSettings(
    selectedTheme: inout String,
    selectedDifficulty: inout String,
    selectedMode: inout String,
    selectedLanguage: inout String,
    readJson: ConvertJson
) {
    // Update selected language based on the current language setting
    if selectedLanguage == "English" || selectedLanguage == "Tiếng Anh" {
        selectedLanguage = readJson.localizedString(forKey: "language1")
    } else {
        selectedLanguage = readJson.localizedString(forKey: "language2")
    }
    
    // Update selected theme based on the current theme setting
    if selectedTheme == "Sáng" || selectedTheme == "Light" {
        selectedTheme = readJson.localizedString(forKey: "themeL")
    } else {
        selectedTheme = readJson.localizedString(forKey: "themeD")
    }

    // Update selected difficulty based on the current difficulty setting
    if selectedDifficulty == "Dễ" || selectedDifficulty == "Easy" {
        selectedDifficulty = readJson.localizedString(forKey: "difficulty1")
    } else if selectedDifficulty == "Trung Bình" || selectedDifficulty == "Medium" {
        selectedDifficulty = readJson.localizedString(forKey: "difficulty2")
    } else {
        selectedDifficulty = readJson.localizedString(forKey: "difficulty3")
    }
    
    // Update selected mode based on the current mode setting
    if selectedMode == "Tiêu Chuẩn" || selectedMode == "Standard" {
        selectedMode = readJson.localizedString(forKey: "mode1")
    } else {
        selectedMode = readJson.localizedString(forKey: "mode2")
    }
}
