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

// Represents a player in the game (LeaderboardView)
struct Player: Identifiable, Codable {
    var id = UUID()         // Unique identifier for the player
    var name: String        // Player's name
    var win: Int            // Number of wins
    var avatar: String      // filename of the player's avatar
}
