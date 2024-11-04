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

// Manages player balance and game wins
class ControlPlayerBalance: ObservableObject {
    // AppStorage property to persist the selected difficulty level
    @AppStorage("selectedDifficulty") private var selectedDifficulty = "Easy"
    
    // Published properties to track game wins and player balance
    @Published var gameWin: Int = 0
    @Published var balance: Int = 50
    
    // Function to adjust the player's balance based on win/lose and double settings
    func adjustBalance(forWin: Bool, forDouble: Bool) {
        let adjustment: Int
        
        // Determine adjustment amount based on the selected difficulty
        switch selectedDifficulty {
            case "Medium", "Trung Bình":
                adjustment = forWin ? 100 : -100
            case "Hard", "Khó":
                adjustment = forWin ? 1000 : -1000
            default:
                adjustment = forWin ? 10 : -10
        }
        
        // Increment game win count if the player won
        if forWin {
            gameWin += 1
        }
        
        // Adjust balance based on whether the player doubled the bet
        if forDouble {
            balance += adjustment * 2
        } else {
            balance += adjustment
        }
    }
    
    // Function to return the mode bet based on the selected difficulty
    func modeBet() -> Int {
        let bet: Int
        
        // Determine bet amount based on the selected difficulty
        switch selectedDifficulty {
            case "Medium", "Trung Bình":
                bet = 100
            case "Hard", "Khó":
                bet = 1000
            default:
                bet = 10
        }
        return bet
    }
    
    // Function to return the mode bet based on the selected difficulty ~ use for alert in setting
    func getBet(selectedDifficulty: String) -> Int {
            switch selectedDifficulty {
                case "Medium", "Trung Bình":
                    return 100
                case "Hard", "Khó":
                    return 1000
                default:
                    return 10
            }
        }

    
    // Function to reset the player's balance and win count
    func resetPlayer() {
        balance = 50
        gameWin = 0
    }
}
