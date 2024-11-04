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

// This extension adds a method to the View type to check if the current device is an iPhone.
extension View {
    // Method to check if the device is an iPhone
    func isPhone() -> Bool {
        // Returns true if the current device is an iPhone
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}
