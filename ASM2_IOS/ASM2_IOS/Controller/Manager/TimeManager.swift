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
import Combine

// Manages a countdown timer with start, stop, and reset functionalities
class TimeManager: ObservableObject {
    // Published properties for time remaining, timer state, and end status
    @Published var timeRemaining: TimeInterval = 10
    @Published var isRunning: Bool = false
    @Published var hasEnded: Bool = false
    
    // Private property for the timer instance
    private var timer: Timer?

    // Starts the countdown timer
    func startTimer() {
        resetTimer()  // Ensure everything is reset before starting
        isRunning = true
        timeRemaining = 10
        hasEnded = false
        
        // Schedule a timer to tick every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Decrease timeRemaining every second
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                // Mark the timer as ended and stop it
                self.hasEnded = true
                self.stopTimer()
            }
        }
    }

    // Stops the countdown timer
    func stopTimer() {
        timer?.invalidate()  // Invalidate the timer to stop it
        timer = nil  // Clear the reference to the timer
        isRunning = false  // Update the running state
        // Optionally, you can handle additional logic when the timer stops
    }

    // Resets the countdown timer to its initial state
    func resetTimer() {
        timer?.invalidate()  // Stop the timer if it's running
        timer = nil  // Clear the reference to the timer
        isRunning = false
        hasEnded = false  // Reset the end state
        timeRemaining = 10  // Reset the countdown to the initial value
    }
}
