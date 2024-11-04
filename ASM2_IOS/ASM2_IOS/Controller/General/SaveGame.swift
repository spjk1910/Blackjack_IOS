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

// Struct to represent the state of the game, conforming to Codable for encoding/decoding
struct SaveGame: Codable {
    var playerCards: [CardClass]
    var dealerCards: [CardClass]
    var balance: Int
    var gameStatus: String?
    var gameWin: Int
    var deckCards: [CardClass]
    var isDealing: Bool
}

// Key used for saving/loading game state in UserDefaults
private let saveKey = "saveGame"

// Function to save the current game state to UserDefaults
private func saveGameState(
    playerCards: [CardClass],
    dealerCards: [CardClass],
    balance: Int,
    gameStatus: String?,
    gameWin: Int,
    deckCards: [CardClass],
    isDealing: Bool
) {
    // Create SaveGame instance with the current game state
    let gameState = SaveGame(
        playerCards: playerCards,
        dealerCards: dealerCards,
        balance: balance,
        gameStatus: gameStatus,
        gameWin: gameWin,
        deckCards: deckCards,
        isDealing: isDealing
    )
    
    do {
        // Encode SaveGame instance to JSON data
        let encoded = try JSONEncoder().encode(gameState)
        // Save encoded data to UserDefaults
        UserDefaults.standard.set(encoded, forKey: saveKey)
    } catch {
        // Handle encoding errors
        print("Failed to encode game state: \(error.localizedDescription)")
    }
}

// Function to load the game state from UserDefaults
func loadGameState() -> SaveGame? {
    // Retrieve saved data from UserDefaults
    guard let savedData = UserDefaults.standard.data(forKey: saveKey) else { return nil }
    
    do {
        // Decode JSON data to SaveGame instance
        let gameState = try JSONDecoder().decode(SaveGame.self, from: savedData)
        return gameState
    } catch {
        // Handle decoding errors
        print("Failed to decode game state: \(error.localizedDescription)")
        return nil
    }
}
