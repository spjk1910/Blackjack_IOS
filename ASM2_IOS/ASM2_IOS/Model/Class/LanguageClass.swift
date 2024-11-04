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

// Represents the language options for the app
struct LanguageClass: Codable {
    let en: LanguageOption  // English language options
    let vi: LanguageOption  // Vietnamese language options
}

// Contains the translations for a specific language
struct LanguageOption: Codable {
    let translation: [String: String]  // Key-value pairs for translations
}
