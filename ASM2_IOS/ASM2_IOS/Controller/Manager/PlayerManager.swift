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

// Manages a list of players and their data
class PlayerManager: ObservableObject {
    // Published property for the list of players
    @Published var players: [Player] = [] {
        didSet {
            savePlayers()
        }
    }

    // Key used for saving/loading players in UserDefaults
    private let playersKey = "savedPlayers"

    // Initializer to load players when the class is instantiated
    init() {
        loadPlayers()
    }
    
    // Saves the current list of players to UserDefaults
    func savePlayers() {
        do {
            // Sort players by the number of wins in descending order
            let sortedPlayers = players.sorted { $0.win > $1.win }
            // Encode sorted players to JSON data
            let encoded = try JSONEncoder().encode(sortedPlayers)
            // Save encoded data to UserDefaults
            UserDefaults.standard.set(encoded, forKey: playersKey)
        } catch {
            // Handle encoding errors
            print("Failed to encode players: \(error.localizedDescription)")
        }
    }

    // Loads the list of players from UserDefaults
    func loadPlayers() {
        if let savedPlayersData = UserDefaults.standard.data(forKey: playersKey) {
            do {
                // Decode JSON data to an array of Player objects
                let decodedPlayers = try JSONDecoder().decode([Player].self, from: savedPlayersData)
                // Update players property with decoded data
                self.players = decodedPlayers
            } catch {
                // Handle decoding errors
                print("Failed to decode players: \(error.localizedDescription)")
            }
        }
    }
}
