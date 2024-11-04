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

// Represents the rank of a card with associated values
enum Rank: CaseIterable, Codable {
    case Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King
    
    // Returns the value of the rank for game calculations
    var value: Int {
        switch self {
            case .Ace: return 11
            case .Two: return 2
            case .Three: return 3
            case .Four: return 4
            case .Five: return 5
            case .Six: return 6
            case .Seven: return 7
            case .Eight: return 8
            case .Nine: return 9
            case .Ten: return 10
            case .Jack: return 10
            case .Queen: return 10
            case .King: return 10
        }
    }
}

// Represents the suit of a card
enum Suit: CaseIterable, Codable {
    case Club, Spade, Heart, Diamond
}

// Represents a single card with rank and suit
struct CardClass: Identifiable, Codable {
    var id = UUID()  // Unique identifier for the card
    var rank: Rank  // Rank of the card
    var suit: Suit  // Suit of the card
    
    // Returns the card's name in a readable format
    var cardName: String {
        return "\(rank)\(suit)"
    }
    
    // Returns the card's value based on its rank
    var cardValue: Int {
        return rank.value
    }
}

// Type alias for a stack of cards
typealias Stack = [CardClass]

// Represents a deck of cards with methods to manipulate it
struct CardDeck: Codable {
    private var cards = Stack()  // Stack to hold the deck of cards
    
    // Creates a standard deck of cards
    mutating func createDeck() {
        cards.removeAll()  // Clear any existing cards
        
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                cards.append(CardClass(rank: rank, suit: suit))
            }
        }
    }
    
    // Shuffles the cards in the deck
    mutating func shuffle() {
        cards.shuffle()
    }
    
    // Draws a card from the deck
    mutating func drawCard() -> CardClass {
        return cards.removeLast()
    }
    
    // Returns the number of cards remaining in the deck
    func cardsRemaining() -> Int {
        return cards.count
    }
    
    // Updates the deck with a new set of cards
    mutating func updateDeck(with deck: [CardClass]) {
        cards = deck
    }
    
    // Returns the current deck of cards
    func Deck() -> [CardClass] {
        return cards
    }
}
