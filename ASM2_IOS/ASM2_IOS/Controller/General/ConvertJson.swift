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

// Class to manage JSON conversion for language translations
class ConvertJson: ObservableObject {
    // Published properties to store translations and selected language
    @Published var translations: [String: String] = [:]
    @Published var selectedLanguage: String = "en" {
        didSet {
            // Load the language options whenever the selected language changes
            loadOption()
        }
    }

    // Initializer to load language options when the class is instantiated
    init() {
        loadOption()
    }

    // Function to load translation options from a JSON file
    func loadOption() {
        // Check if the "Language.json" file exists in the main bundle
        guard let url = Bundle.main.url(forResource: "Language", withExtension: "json") else {
            print("Language.json not found")
            return
        }

        do {
            // Load data from the JSON file
            let data = try Data(contentsOf: url)
            // Decode the data into a LanguageClass object
            let decodedOption = try JSONDecoder().decode(LanguageClass.self, from: data)
            // Assign translations based on the selected language
            translations = selectedLanguage == "en" ? decodedOption.en.translation : decodedOption.vi.translation
        } catch {
            // Handle errors during JSON decoding
            print("Error decoding JSON: \(error)")
        }
    }

    // Function to get a localized string for a given key
    func localizedString(forKey key: String) -> String {
        // Return the localized string if available, otherwise return the key itself
        return translations[key] ?? key
    }
}
