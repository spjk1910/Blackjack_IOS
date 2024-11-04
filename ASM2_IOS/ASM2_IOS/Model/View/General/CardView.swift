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

// A view that displays a card image based on the card's name.
struct CardView: View {
    let cardName: String // Name of the card image to be displayed
    
    var body: some View {
        Image(cardName) // Load the image with the given card name
            .resizable() // Make the image resizable
            .aspectRatio(2/3, contentMode: .fit) // Maintain aspect ratio and fit content
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample card and preview the CardView
        let card = CardClass(rank: .Jack, suit: .Diamond)
        CardView(cardName: card.cardName)
    }
}
